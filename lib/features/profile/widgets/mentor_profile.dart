import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class MentorProfileWidget extends StatelessWidget {
  final UserModel user;
  const MentorProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: user.name),
        const Divider(),
        const LogoutWidget(),
      ],
    );
  }
}
