import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class TaskEmptyWidget extends StatelessWidget {
  const TaskEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF04060F).withOpacity(0.08),
                  blurRadius: 60,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 22),
                Image.asset(
                  'assets/images/2187-min.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                const AppText(
                  text: 'Нет заданий на сегодня',
                  size: 24,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const AppText(
                  text: 'Добавьте задание,\nнажав кнопку (+) ниже',
                  fw: FontWeight.normal,
                  textAlign: TextAlign.center,
                  color: greyscale700,
                  maxLine: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
