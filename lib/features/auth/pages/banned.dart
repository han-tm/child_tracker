

import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BannedScreen extends StatelessWidget {
  const BannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.clear_circled, size: 70, color: red),
            SizedBox(height: 8),
            AppText(text: 'Вы заблокированы', size: 17, fw: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}