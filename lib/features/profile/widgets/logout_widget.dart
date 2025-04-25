import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  void onLogout(BuildContext context) {
    showLogoutDialog(context);
  }

  void onDelete(BuildContext context) {
    showDeleteAccountDialog(context);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(onPressed: () => onLogout(context), child: const Text('Выйти из аккаунта')),
        TextButton(onPressed: () => onDelete(context), child: const Text('Удалить аккаунт')),
      ],
    );
  }
}
