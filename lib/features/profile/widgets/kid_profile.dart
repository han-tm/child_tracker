import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class KidProfileWidget extends StatelessWidget {
  final UserModel user;
  const KidProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RobotoText(text: user.name),
        const Divider(),
        const LogoutWidget(),
      ],
    );
  }
}
