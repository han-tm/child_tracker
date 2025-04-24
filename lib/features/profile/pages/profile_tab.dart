
import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const RobotoText(text: 'Profile'),
      ),
    );
  }
}