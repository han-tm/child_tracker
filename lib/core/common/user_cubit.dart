import 'package:cloud_firestore/cloud_firestore.dart';
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
}
