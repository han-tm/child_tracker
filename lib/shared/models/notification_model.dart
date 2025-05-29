

class NotificationModel {
  final String title;
  final String? decoration;
  final bool isRead;
  final DateTime date;

  NotificationModel({
    required this.title,
    this.isRead = false,
    required this.date,
    this.decoration,
  });
}
