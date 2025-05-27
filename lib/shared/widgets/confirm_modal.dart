import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmModalBottomSheet(
  BuildContext context, {
  String title = 'Подтвердите действие',
  bool isDestructive = false,
  String confirmText = 'Подтвердить',
  String cancelText = 'Отмена',
  String message = '?',
}) async {
  return showModalBottomSheet<bool?>(
    context: context,
    backgroundColor: white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: greyscale200,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            AppText(
              text: title,
              size: 24,
              color: isDestructive ? red : secondary900,
              fw: FontWeight.w700,
            ),
            const Divider(height: 48, thickness: 1, color: greyscale200),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/mascot_1.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(child: LeftArrowBubleShape(child: AppText(text: message, size: 20))),
              ],
            ),
            const Divider(height: 48, thickness: 1, color: greyscale200),
            Row(
              children: [
                Expanded(
                  child: FilledSecondaryAppButton(
                    text: cancelText,
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledAppButton(
                    text: confirmText,
                    onTap: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],
        ),
      );
    },
  );
}
