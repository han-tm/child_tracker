
import 'package:child_tracker/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _LogoutAlertDialog extends StatelessWidget {
  const _LogoutAlertDialog();

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
            const AppText(
              text: 'Вы действительно хотите выйти из аккаунта?',
              textAlign: TextAlign.center,
              size: 20,
              fw: FontWeight.w500,
            ),
            const SizedBox(height: 24),
            FilledAppButton(
              text: 'Выйти',
              onTap: () => Navigator.of(context).pop(true),
              fontSize: 17,
              fw: FontWeight.w500,
            ),
            const SizedBox(height: 16),
            FilledAppButton(
              text: 'Отменить',
              onTap: () => Navigator.of(context).pop(false),
              fontSize: 17,
              fw: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}

void showLogoutDialog(BuildContext context) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) => const _LogoutAlertDialog(),
  );

  if (result == true) {
    final StorageService storageService = sl();
    await storageService.clearAllStorage();
    if (context.mounted) await context.read<UserCubit>().onDeleteFcmToken();
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      context.go('/auth');
    }
  }
}
