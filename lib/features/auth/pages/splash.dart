

import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirectFunc(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Image.asset(
          'assets/images/android12_splash_logo.png',
          width: 200,
          fit: BoxFit.contain,
        ),
      )),
    );
  }
}
