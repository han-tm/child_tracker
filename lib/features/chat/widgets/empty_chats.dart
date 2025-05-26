
import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class EmptyChatsWidget extends StatelessWidget {
  const EmptyChatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppText(text: 'Нет чатов', size: 17, fw: FontWeight.w500));
  }
}