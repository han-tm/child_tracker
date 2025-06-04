import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class TaskChip extends StatelessWidget {
  final String label;
  final bool selected;
  const TaskChip({super.key, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: selected ? primary900 : null,
        borderRadius: BorderRadius.circular(100),
        border: selected ? null : Border.all(color: primary900, width: 1.5),
      ),
      child: Center(
        child: AppText(
          text: label,
          size: 14,
          color: selected ? white : primary900,
        ),
      ),
    );
  }
}
