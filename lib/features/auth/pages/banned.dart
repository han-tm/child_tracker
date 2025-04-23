

import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BannedScreen extends StatelessWidget {
  const BannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.clear_circled, size: 70, color: appRed),
            SizedBox(height: 8),
            RobotoText(text: 'Вы заблокированы', size: 17, fw: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}