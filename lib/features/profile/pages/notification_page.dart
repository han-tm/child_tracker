import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title:  AppText(text: 'notifications'.tr(), size: 24, fw: FontWeight.w700),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/setting.svg',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              onPressed: () {
                showNotificationSettingModalBottomSheet(context);
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserModel?>(
        builder: (context, user) {
          if (user == null) return const SizedBox();
          return StreamBuilder<List>(
              stream: getNotifications(user.ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final notifications = snapshot.data!;
                if (notifications.isEmpty) return const EmptyNotificationsWidget();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(notification: notifications[index]);
                  },
                );
              });
        },
      ),
    );
  }
}

Stream<List<NotificationModel>> getNotifications(DocumentReference ref) {
  return ref
      .collection('notifications')
      // .where('user', isEqualTo: ref)
      // .orderBy('created_at', descending: true)
      .snapshots()
      .map((docs) => docs.docs.map((doc) => NotificationModel(title: 'Title', date: DateTime.now())).toList());
}
