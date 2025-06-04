


import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class KidTaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  const KidTaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if(tasks.isEmpty){
      return const TaskEmptyWidget();
    }
    return const Placeholder();
  }
}