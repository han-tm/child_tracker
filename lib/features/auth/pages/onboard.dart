


import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {

  @override
  void initState() {
    super.initState();
    redirectFunc(context);
  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: primaryBackground,
      body: Center(child: RobotoText(text: 'Onboard')),
    );
  }
}