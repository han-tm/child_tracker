import 'dart:developer';

import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart' as cf;

class FirebaseMessaginService {
  final FirebaseMessaging _fcm;
  final FirebaseFirestore _fs;
  final UserCubit _userCubit;
  final cf.FirebaseFunctions _functions;
  final LocalNotificationService _localNotificationService;

  FirebaseMessaginService(
      {required FirebaseMessaging fcm,
      required FirebaseFirestore fs,
      required UserCubit appUserCubit,
      required cf.FirebaseFunctions functions,
      required LocalNotificationService localNotificationService})
      : _fs = fs,
        _fcm = fcm,
        _userCubit = appUserCubit,
        _functions = functions,
        _localNotificationService = localNotificationService;

  List<String> receivedNotificationIds = [];

  Future<void> setupFCM() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _fcm.getToken();
    await _setFCMToken(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Message: ${message.messageId} TITLE: ${message.notification?.title}:  BODY: ${message.notification?.body} \n DATA: ${message.data}');
      final notification = message.notification;
      if (notification != null) {
        bool alreadyView = isNotificationReceived(message.messageId ?? '');
        if (alreadyView) {
          log('Message already viewed: ${message.messageId}');
          return;
        }
        // _localNotificationService.showFCMNotificationForeground(
        //   title: notification.title ?? 'Notification',
        //   body: notification.body ?? '',
        // );
        SnackBarSerive.showSnackBarOnReceivePushNotification(
          notification.title ?? 'Notification',
          notification.body,
          null,
        );
      }
    });
  }

  bool isNotificationReceived(String id) => receivedNotificationIds.contains(id);

  Future<void> _setFCMToken(String? token) async {
    if (token == null) return;
    await _userCubit.state?.ref.update({'fcm_token': token});
  }
}
