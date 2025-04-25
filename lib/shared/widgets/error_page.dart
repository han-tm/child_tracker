import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    print(error);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ошибка'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RobotoText(
            text: "Произошла ошибка",
            size: 17,
            fw: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          RobotoText(
            text: error,
            textAlign: TextAlign.center,
            color: secondaryText,
          ),
        ],
      ),
    );
  }
}
