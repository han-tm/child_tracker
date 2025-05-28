import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_tracker/index.dart';

class UserCubit extends Cubit<UserModel?> {
  final FirebaseFirestore _fs;

  UserCubit({
    required FirebaseFirestore fs,
  })  : _fs = fs,
        super(null);

  void setUser(UserModel? newUser) => emit(newUser);

  void getUser() {
    _fs.app;
  }

  Future<void> getAndSet(User user) async {
    try {
      final doc = await _fs.collection('users').doc(user.uid).get();
      final userModel = UserModel.fromFirestore(doc);
      setUser(userModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onDeleteFcmToken() async {
    await state?.ref.update({'fcm_token': null});
  }

  Future<void> markAsDeleted() async {
    await state?.ref.update({
      'deleted': true,
      'banned': null,
      'photo': null,
      'type': null,
      'email': null,
      'phone': null,
    });
  }
}
