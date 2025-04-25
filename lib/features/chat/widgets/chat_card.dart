import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  final int unreads;
  const ChatCard({super.key, required this.chat, this.unreads = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/kid/chat/room/${chat.id}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 20, backgroundColor: appRed),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RobotoText(text: '${chat.lastMessage?.senderId}', fw: FontWeight.w500, maxLine: 1),
                  RobotoText(
                    text: '${chat.lastMessage?.text}',
                    size: 14,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RobotoText(
                  text: dateToStringDDMMYYYY(chat.updatedAt),
                  color: secondaryText,
                  size: 12,
                ),
                if (unreads > 0)
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: appRed,
                    child: Center(
                      child: RobotoText(text: '$unreads', size: 8, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
