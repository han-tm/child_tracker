import 'package:child_tracker/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final UserCubit _userCubit;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  String? phoneNumber; // Сохраняем номер телефона для повторной отправки
  int? resendToken; // Токен для повторной отправки

  PhoneAuthCubit({required UserCubit userCubit})
      : _userCubit = userCubit,
        super(PhoneAuthInitial());

  Future<void> sendOTP(String phoneNumber) async {
    emit(PhoneAuthLoading());
    phoneNumber = phoneNumber; // Сохраняем номер телефона
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
          resendToken = resendToken; // Сохраняем resendToken
          emit(PhoneAuthCodeSentSuccess());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          emit(PhoneAuthCodeAutoRetrievalTimeout());
        },
      );
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> resendOTP() async {
    if (phoneNumber == null) {
      emit(PhoneAuthFailure(errorMessage: 'Номер телефона не найден. Пожалуйста, введите номер телефона заново.'));
      return;
    }
    emit(PhoneAuthLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
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
          resendToken = resendToken;
          emit(PhoneAuthCodeSentSuccess());
          emit(PhoneAuthResendOTPSuccess()); // Добавляем новое состояние
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          emit(PhoneAuthCodeAutoRetrievalTimeout());
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
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: mapFirebaseErrorCodeToMessage((e as FirebaseAuthException).code)));
    }
  }

  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(PhoneAuthSuccess(user: userCredential.user!));
      } else {
        emit(PhoneAuthFailure(errorMessage: 'Ошибка входа. Пожалуйста, попробуйте еще раз.'));
      }
    } catch (e) {
      emit(PhoneAuthFailure(errorMessage: mapFirebaseErrorCodeToMessage((e as FirebaseAuthException).code)));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(PhoneAuthInitial());
  }

  void testEnter() async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(email: 'kid1@user.com', password: '123456');
    await _userCubit.getAndSet(cred.user!);
    emit(PhoneAuthSuccess(user: cred.user!));
  }
}
