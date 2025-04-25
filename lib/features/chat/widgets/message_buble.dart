

import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: message.senderId == sl<UserCubit>().state?.id ? primary : secondaryText,
            ),
            child: RobotoText(text: message.text),
          ),
        ),
      ],
    );
  }
}