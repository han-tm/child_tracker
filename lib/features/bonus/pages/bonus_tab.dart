import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class BonusTabScreen extends StatelessWidget {
  const BonusTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const RobotoText(text: 'Bonus'),
      ),
    );
  }
}