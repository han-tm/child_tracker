import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class GamesTabScreen extends StatelessWidget {
  const GamesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Games'),
      ),
    );
  }
}