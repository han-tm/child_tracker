
import 'package:child_tracker/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class _DeleteAccountAlertDialog extends StatelessWidget {
  const _DeleteAccountAlertDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const RobotoText(
              text: 'Вы действительно хотите удалить аккаунт?',
              textAlign: TextAlign.center,
              size: 20,
              fw: FontWeight.w500,
            ),
            const SizedBox(height: 24),
            FilledAppButton(
              text: 'Удалить',
              onPress: () => Navigator.of(context).pop(true),
              fontSize: 17,
              fw: FontWeight.w500,
            ),
            const SizedBox(height: 16),
            FilledAppButton(
              text: 'Отменить',
              onPress: () => Navigator.of(context).pop(false),
              fontSize: 17,
              fw: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AccountDeletionDialog(),
  );
}


void showDeleteAccountDialog(BuildContext context) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) => const _DeleteAccountAlertDialog(),
  );

  if (result == true && context.mounted) {
    _showDeleteAccountDialog(context);
  }
}

class AccountDeletionDialog extends StatefulWidget {
  const AccountDeletionDialog({super.key});

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

    final phone = context.read<UserCubit>().state?.phone;

    if (phone == null) return;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
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
      if (mounted) context.go('/auth');
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка верификации: $e')),
        );
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
      title: const RobotoText(text: 'Удаление аккаунта', fw: FontWeight.w500),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RobotoText(
            text: 'Для безопасного удаления аккаунта '
                'требуется повторная аутентификация',
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
                textStyle: const TextStyle(fontSize: 24, color: primaryText, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: borderColor),
                ),
              ),
              focusedPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: primaryText, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: primary),
                ),
              ),
              followingPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: primaryText, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: borderColor),
                ),
              ),
              submittedPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: primaryText, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: borderColor),
                ),
              ),
              errorPinTheme: PinTheme(
                height: ph,
                width: pw,
                textStyle: const TextStyle(fontSize: 24, color: primaryText, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: appRed),
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
