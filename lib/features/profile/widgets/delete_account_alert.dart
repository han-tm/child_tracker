import 'package:child_tracker/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

void _showDeleteAccountDialog(BuildContext context, String phone) {
  showDialog(
    context: context,
    builder: (context) => AccountDeletionDialog(phone: phone),
  );
}

void showDeleteAccountDialog(BuildContext context) async {
  final result = await showConfirmModalBottomSheet(
    context,
    isDestructive: true,
    confirmText: 'Да, удалить',
    title: 'Удалить аккаунт',
    message: 'Ох..., точно удалить?',
  );

  if (result == true && context.mounted) {
    final phone = context.read<UserCubit>().state?.phone;
    print(phone);
    if (phone == null) return;
    _showDeleteAccountDialog(context, phone);
  }
}

class AccountDeletionDialog extends StatefulWidget {
  final String phone;
  const AccountDeletionDialog({super.key, required this.phone});

  @override
  // ignore: library_private_types_in_public_api
  _AccountDeletionDialogState createState() => _AccountDeletionDialogState();
}

class _AccountDeletionDialogState extends State<AccountDeletionDialog> {
  String? _verificationId;
  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationCode();
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      _isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _deleteAccount(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка верификации: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _deleteAccount(PhoneAuthCredential credential) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      await currentUser?.reauthenticateWithCredential(credential);
      await currentUser?.delete();
      if (mounted) await context.read<UserCubit>().markAsDeleted();
      final StorageService storageService = sl();
      await storageService.clearAllStorage();
      if (mounted) context.go('/logout_result');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления аккаунта: $e')),
        );
      }
    }
  }

  Future<void> _verifyCode(String pin) async {
    if (_verificationId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: pin,
      );

      await _deleteAccount(credential);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const ph = 45.0;
    const pw = 45.0;
    return AlertDialog(
      title: const AppText(text: 'Удаление аккаунта', fw: FontWeight.w500),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText(
            text: 'Для безопасного удаления аккаунта '
                'требуется повторная аутентификация',
            maxLine: 5,
            size: 14,
            fw: FontWeight.w500,
            color: greyscale700,
          ),
          const SizedBox(height: 24),
          if (_isLoading) const CircularProgressIndicator(),
          if (_isCodeSent && !_isLoading)
            Pinput(
              length: 6,
              onCompleted: (v) => _verifyCode(v),
              separatorBuilder: (index) => const SizedBox(width: 10),
              defaultPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: greyscale200),
                ),
              ),
              focusedPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: primary900),
                ),
              ),
              followingPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: greyscale200),
                ),
              ),
              submittedPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: greyscale200),
                ),
              ),
              errorPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: red),
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
