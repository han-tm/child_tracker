
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String name;
  final String? photo;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;
  final DocumentReference? owner;
  final DateTime? reminderDate;
  final DateTime? reminderTime;
  final List<int>? reminderDays;

  TaskModel({
    required this.name,
    this.photo,
    this.startDate,
    this.endDate,
    this.description,
    this.owner,
    this.reminderDate,
    this.reminderTime,
    this.reminderDays,
  });
}
