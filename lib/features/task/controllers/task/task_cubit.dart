import 'dart:async';

import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class TaskCubit extends Cubit<TaskState> {
  final UserCubit _userCubit;
  final FirebaseFirestore _fs;

  TaskCubit({
    required UserCubit userCubit,
    required FirebaseFirestore fs,
  })  : _userCubit = userCubit,
        _fs = fs,
        super(TaskState(currentDay: DateTime.now()));

  StreamSubscription? _taskStreamSubscription;

  void init() {
    final me = _userCubit.state;
    if (me == null) return;
    emit(state.copyWith(status: TaskStateStatus.loading));

    late Query query;

    if (me.isKid) {
      query = _fs
          .collection('tasks')
          .where('kid', isEqualTo: me.ref)
          .where('status', isNotEqualTo: TaskStatus.deleted.name)
          .orderBy('created_at', descending: true);
    } else {
      query = _fs
          .collection('tasks')
          .where('owner', isEqualTo: me.ref)
          .where('status', isNotEqualTo: TaskStatus.deleted.name)
          .orderBy('created_at', descending: true);

      final selectedKid = state.selectedKid;
      if (selectedKid != null) {
        query = query.where('kid', isEqualTo: selectedKid.ref);
      }
    }

    print(query.parameters);

    _taskStreamSubscription = query.snapshots().listen((event) {
      final tasks = event.docs.map((e) => TaskModel.fromFirestore(e)).toList();
      emit(state.copyWith(tasks: tasks, status: TaskStateStatus.success));
    })
      ..onError(
        (_, e) {
          emit(state.copyWith(errorMessage: e.toString(), status: TaskStateStatus.error));
        },
      );
  }

  void onKidSelected(UserModel? kid) {
    if (kid == null) {
      emit(state.resetSelectedKid());
    } else {
      emit(state.copyWith(selectedKid: kid));
    }
    init();
  }

  void onKidTaskChipSelected(KidTaskChip chip) {
    emit(state.copyWith(selectedKidChip: chip));
  }

  void onChangeDate(DateTime date) {
    emit(state.copyWith(currentDay: date));
  }

  void cancelTask(TaskModel task, String? reason) async {
    emit(state.copyWith(status: TaskStateStatus.canceling));
    try {
      await task.ref.update({'status': TaskStatus.canceled.name, 'cancel_reason': reason});
      emit(state.copyWith(status: TaskStateStatus.cancelSuccess));
    } catch (e) {
      print('error: {cancelTask}: ${e.toString()}');
      emit(state.copyWith(status: TaskStateStatus.cancelError, errorMessage: e.toString()));
    }
  }

  Future<bool> deleteTask(TaskModel task) async {
    try {
      await task.ref.update({'status': TaskStatus.deleted.name});
      return true;
    } catch (e) {
      print('error: {deleteTask}: ${e.toString()}');
      return false;
    }
  }

  Future<bool> completeTask(TaskModel task) async {
    try {
      await task.ref.update({'status': TaskStatus.completed.name});
      return true;
    } catch (e) {
      print('error: {completeTask}: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<void> close() {
    _taskStreamSubscription?.cancel();
    return super.close();
  }
}
