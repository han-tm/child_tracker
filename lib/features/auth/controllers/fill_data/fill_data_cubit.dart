import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'state.dart';

class FillDataCubit extends Cubit<FillDataState> {
  final UserCubit _userCubit;
  final FirebaseAuth _auth;
  final FirebaseFirestore _fs;
  final PageController pageController;

  FillDataCubit({
    required UserCubit userCubit,
    required FirebaseAuth auth,
    required FirebaseFirestore fs,
  })  : _userCubit = userCubit,
        _auth = auth,
        _fs = fs,
        pageController = PageController(initialPage: 0),
        super(const FillDataState());

  void onChangeType(UserType type) {
    emit(state.copyWith(userType: type));
  }

  void onChangeName(String name) {
    emit(state.copyWith(name: name));
  }

  void onChangeAge(int age) {
    emit(state.copyWith(age: age));
  }

  void onChangeCity(String city) {
    emit(state.copyWith(city: city));
  }

  void onChangePhoto(XFile photo) {
    emit(state.copyWith(photo: photo));
  }

  void nextPage() {
    if (state.step == 4 && state.userType == UserType.kid) {
      print('createUser kid');
      createUser();
    } else if (state.step == 1 && state.userType == UserType.mentor) {
      print('createUser mentor');
        createUser();
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      emit(state.copyWith(step: state.step + 1));
    }
  }

  void prevPage() {
    if (state.step == 0) return;
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    emit(state.copyWith(step: state.step - 1));
  }

  Future<void> createUser() async {
    if (_auth.currentUser == null) {
      emit(state.copyWith(status: FillDataStatus.error, errorMessage: 'Пользователь не найден'));
      return;
    }

    if (state.userType == null || state.name == null || state.photo == null) {
      emit(state.copyWith(status: FillDataStatus.error, errorMessage: 'Заполните все поля'));
      return;
    }

    emit(state.copyWith(status: FillDataStatus.loading));

    try {
      Map<String, dynamic> data = state.userType == UserType.kid ? _getKidData() : _getMentorData();

      // final uploadService = FirebaseStorageService();
      // final photoUrl = await uploadService.uploadFile(
      //   file: state.photo!,
      //   type: UploadType.user,
      //   uid: _auth.currentUser!.uid,
      // );
      // if (photoUrl == null) {
      //   emit(state.copyWith(status: FillDataStatus.error, errorMessage: 'Ошибка загрузки фото'));
      //   return;
      // } else {
      //   data['photo'] = photoUrl;
      // }

      final orderRef = _fs.collection('users').doc(_auth.currentUser!.uid);
      await orderRef.update(data);
      await _userCubit.getAndSet(_auth.currentUser!);
      emit(state.copyWith(status: FillDataStatus.success));
    } catch (e) {
      print('Произошла ошибка {createUser}: $e');
      emit(state.copyWith(status: FillDataStatus.error, errorMessage: '$e'));
    }
  }

  Map<String, dynamic> _getMentorData() {
    Map<String, dynamic> userData = {
      'type': state.userType!.name,
      'name': state.name!,
      'profile_filled': true,
      'trial_subscription': DateTime.now().add(const Duration(days: 30)),
    };
    return userData;
  }

  Map<String, dynamic> _getKidData() {
    Map<String, dynamic> userData = {
      'type': state.userType!.name,
      'name': state.name!,
      'profile_filled': true,
      'age': state.age,
      'city': state.city,
    };
    return userData;
  }

  void reset() => emit(state.reset());

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
