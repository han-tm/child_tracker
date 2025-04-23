// ignore_for_file: deprecated_member_use


import 'package:bot_toast/bot_toast.dart';
import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SnackBarSerive {
  static const Duration duration = Duration(seconds: 6);

  static showSuccessSnackBar(BuildContext context, String title) {
    BotToast.showCustomNotification(
      duration: duration,
      toastBuilder: (cancelFunc) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primary),
            boxShadow: [
              BoxShadow(
                blurRadius: 32,
                color: const Color(0xFFC4AC88).withOpacity(0.32),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.check_mark, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(
                child: RobotoText(
                  text: title,
                  size: 16,
                  fw: FontWeight.w600,
                  color: primaryText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static showErrorSnackBar(BuildContext context, String title) {
    BotToast.showCustomNotification(
      duration: duration,
      toastBuilder: (cancelFunc) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0x00000000).withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 32,
                color: const Color(0xFFC4AC88).withOpacity(0.32),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.clear_circled, color: appRed),
              const SizedBox(width: 10),
              Expanded(
                child: RobotoText(
                  text: title,
                  size: 16,
                  fw: FontWeight.w600,
                  color: secondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static showBottomSnackBar(BuildContext context, String title) {
    BotToast.showText(
      text: title,
      align: Alignment.bottomCenter,
      contentColor: primaryText,
      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: secondary),
    );
  }

  static showSnackBarOnReceivePushNotification(
    BuildContext context,
    String title,
    String? body,
    VoidCallback? onTap,
  ) {
    BotToast.showCustomNotification(
      duration: duration,
      crossPage: true,
      toastBuilder: (cancelFunc) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (onTap != null) {
              onTap();
            }
            cancelFunc();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: primaryText,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 32,
                  color: const Color(0xFFC4AC88).withOpacity(0.62),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/bell.svg',
                      width: 24,
                      height: 24,
                      color: primary,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RobotoText(
                            text: title,
                            size: 18,
                            fw: FontWeight.w600,
                            color: primary,
                          ),
                          if (body != null)
                            RobotoText(
                              text: body,
                              size: 16,
                              fw: FontWeight.w500,
                              color: primary,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
