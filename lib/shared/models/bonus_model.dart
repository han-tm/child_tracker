import 'package:child_tracker/index.dart';

class BonusModel {
  final String title;
  final bool isUsed;
  final BonusStatus status;

  BonusModel({
    required this.title,
    required this.status,
    this.isUsed = false,
  });
}
