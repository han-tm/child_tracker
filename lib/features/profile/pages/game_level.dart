import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameLevelScreen extends StatelessWidget {
  const GameLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyscale100,
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: white,
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: AppText(text: 'gameLevel'.tr(), size: 24, fw: FontWeight.w700),
        centerTitle: true,
      ),
      body: Center(
        child: AppText(
          text: 'noRaiting'.tr(),
          size: 15,
          color: greyscale500,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
