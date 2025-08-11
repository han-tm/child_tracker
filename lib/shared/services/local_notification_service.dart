import 'dart:async';



// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class LocalNotificationService {
 

 

  Future<void> setWebNotificationReminder(bool force) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 20, 0, 0);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final delay = scheduledTime.difference(now);

    Timer(delay, () {
      _showWebNotification();
      Timer.periodic(const Duration(days: 1), (timer) {
        _showWebNotification();
      });
    });
  }

  void _showWebNotification() {
    try {
      final notification = html.Notification(
        'Время для дневника!',
        body: 'Не забудьте оставить запись в своем дневнике сегодня.',
        tag: 'diary_reminder',
      );

      Timer(const Duration(seconds: 10), () {
        notification.close();
      });
    } catch (e) {
      print('Ошибка показа уведомления: $e');
    }
  }
}
