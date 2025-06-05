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
    final user = _userCubit.state;
    if (user == null) return;
    emit(state.copyWith(status: TaskStateStatus.loading));

    final query = _fs
        .collection('tasks')
        .where('kid', isEqualTo: user.ref)
        .where('status', isNotEqualTo: TaskStatus.deleted.name)
        .orderBy('created_at', descending: true);

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

  void onKidTaskChipSelected(KidTaskChip chip) {
    emit(state.copyWith(selectedKidChip: chip));
  }

  void onChangeDate(DateTime date) {
    emit(state.copyWith(currentDay: date));
  }

  @override
  Future<void> close() {
    _taskStreamSubscription?.cancel();
    return super.close();
  }
}
