import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class TaskTabScreen extends StatelessWidget {
  const TaskTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const RobotoText(text: 'Task'),
      ),
    );
  }
}