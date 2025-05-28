import 'package:child_tracker/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void showLogoutDialog(BuildContext context) async {
  final result = await showConfirmModalBottomSheet(
    context,
    isDestructive: true,
    confirmText: 'Да, выйти',
    title: 'Выйти из аккаунта',
    message: 'Вы уверены, что хотите выйти?',
  );

  if (result == true) {
    final StorageService storageService = sl();
    await storageService.clearAllStorage();
    if (context.mounted) await context.read<UserCubit>().onDeleteFcmToken();
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      context.go('/logout_result', extra: 'Выход из аккаунта...');
    }
  }
}
