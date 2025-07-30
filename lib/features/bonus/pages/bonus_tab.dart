import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class BonusTabScreen extends StatelessWidget {
  const BonusTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyscale100,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              // SnackBarSerive.showSnackBarOnReceivePushNotification('Привет, Как дела?', 'Нужно выполнить зарядку', null);
            },
            child: const AppText(text: 'Bonus')),
      ),
    );
  }
}
