import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final UserCubit _userCubit;
  final FirebaseAuth _auth;
  final FirebaseFirestore _fs;

  String? _verificationId;
  String? _phoneNumber;
  int? _resendToken;

  PhoneAuthCubit({
    required UserCubit userCubit,
    required FirebaseAuth auth,
    required FirebaseFirestore fs,
  })  : _userCubit = userCubit,
        _auth = auth,
        _fs = fs,
        super(PhoneAuthInitial());

  Future<void> sendOTP(String phoneNumber) async {
    emit(PhoneAuthLoading());
    _phoneNumber = phoneNumber;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          emit(PhoneAuthCodeSentSuccess());
          await signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(PhoneAuthFailure(errorMessage: mapFirebaseErrorCodeToMessage(e.code)));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          emit(PhoneAuthCodeSentSuccess());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          emit(PhoneAuthFailure(errorMessage: 'Время ожидания истекло. Пожалуйста, запросите код заново'));
        },
      );
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> resendOTP() async {
    if (_phoneNumber == null) {
      emit(PhoneAuthFailure(errorMessage: 'Номер телефона не найден. Пожалуйста, введите номер телефона заново.'));
      return;
    }
    emit(PhoneAuthLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber!,
        forceResendingToken: _resendToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          emit(PhoneAuthCodeSentSuccess());
          await signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(PhoneAuthFailure(errorMessage: mapFirebaseErrorCodeToMessage(e.code)));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          // emit(PhoneAuthCodeSentSuccess());
          emit(PhoneAuthResendOTPSuccess());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          emit(PhoneAuthFailure(errorMessage: 'Сессия подтверждения истекла. Пожалуйста, запросите код заново.'));
        },
      );
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> verifyOTP(String otp) async {
    emit(PhoneAuthLoading());
    if (_verificationId == null) {
      emit(PhoneAuthFailure(errorMessage: 'Verification ID не найден. Пожалуйста, запросите OTP заново.'));
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthFailure(errorMessage: mapFirebaseErrorCodeToMessage((e).code)));
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        final userCollection = _fs.collection('users');
        final userData = await userCollection.doc(userCredential.user!.uid).get();

        if (userData.exists) {
          //login

          final userModel = UserModel.fromFirestore(userData);
          if (userModel.banned) {
            emit(PhoneAuthFailure(errorMessage: 'Пользователь заблокирован'));
            return;
          } else if (!userModel.profileFilled) {
            emit(PhoneAuthSuccessRedirect());
            return;
          } else {
            emit(PhoneAuthSuccess(type: (userModel.userType ?? UserType.kid).name));
            _userCubit.setUser(userModel);
            return;
          }
        } else {
          print('Создаем нового пользователя');
          await _createNewUser(userCredential.user!);
          emit(PhoneAuthSuccessRedirect());
        }
      } else {
        emit(PhoneAuthFailure(errorMessage: 'Ошибка входа. Пожалуйста, попробуйте еще раз.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthFailure(errorMessage: mapFirebaseErrorCodeToMessage((e).code)));
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _createNewUser(User user) async {
    try {
      final userCollection = _fs.collection('users');
      Map<String, dynamic> userData = {
        'name': user.displayName ?? 'Неизвестно',
        'phone': _phoneNumber,
        'email': user.email,
        'type': null,
        'profile_filled': false,
        'banned': false,
        'deleted': false,
        'created_at': FieldValue.serverTimestamp(),
      };
      final docRef = userCollection.doc(user.uid);
      await docRef.set(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(PhoneAuthInitial());
  }

  // void testEnter() async {
  //   UserCredential cred = await _auth.signInWithEmailAndPassword(email: 'kid1@user.com', password: '123456');
  //   await _userCubit.getAndSet(cred.user!);
  //   emit(PhoneAuthSuccess(user: cred.user!));
  // }
}
