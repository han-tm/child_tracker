import 'package:child_tracker/app.dart';
import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    final localeCubit = sl<LocaleCubit>();
    await localeCubit.initCurrentLocale();

    runApp(EasyLocalization(
      supportedLocales: LocaleCubit.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      startLocale: localeCubit.state,
      child: BlocProvider.value(
        value: localeCubit,
        child: const App(),
      ),
    ));
  });
}

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Timezone init
//   tz.initializeTimeZones();
//   final String timeZone = await FlutterTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZone));
//   debugPrint('Using timezone: $timeZone');

//   // Init notifications
//   final localNotificationService = LocalNotificationService();
//   await localNotificationService.init();

//   runApp(MyApp(localNotificationService: localNotificationService));
// }

// class MyApp extends StatelessWidget {
//   final LocalNotificationService localNotificationService;

//   const MyApp({super.key, required this.localNotificationService});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Notification Test')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               localNotificationService.scheduleOneTimeNotification(
//                 id: 3,
//                 title: 'Напоминание',
//                 body: 'Сработало через 5 секунд',
//                 scheduledDateTime: DateTime.now().add(const Duration(seconds: 5)),
//               );
//             },
//             child: const Text('Отправить уведомление'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LocalNotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings settings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );

//     await _notificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         debugPrint('Notification tapped: ${details.payload}');
//       },
//     );

//     // Request permissions
//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();

//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   Future<void> scheduleOneTimeNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDateTime,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'one_time_channel_id',
//       'One Time Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//     print('tz locale: ${tz.local}');
//     final tzDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

//     debugPrint('Scheduling notification at $tzDateTime');

//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tzDateTime,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
// }
