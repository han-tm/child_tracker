import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GamePlayScreen extends StatefulWidget {
  final LevelModel level;
  final DocumentReference gameRef;
  const GamePlayScreen({super.key, required this.level, required this.gameRef});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  late PageController controller;
  List<QuizModel> quizzes = [];

  void init(){}


  void onExitGame() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: onExitGame,
        ),
        title: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: StepProgressWidget(
                currentStep: 0,
                plusStep: 0,
                totalSteps: widget.level.games.length,
                showStepCount: false,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ExitGamePopupMenuButton(onExit: onExitGame),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.flip(
                  flipX: true,
                  child: Image.asset(
                    'assets/images/2177-min.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: LeftArrowBubleShape(
                    padding: const EdgeInsets.fromLTRB(40, 5, 10, 5),
                    child: AppText(
                      text: 'selectCorrectAnswer'.tr(),
                      size: 16,
                      fw: FontWeight.w500,
                      color: greyscale800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [],
          ),
          Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FilledAppButton(
                    text: 'apply'.tr(),
                    // isActive: valid,
                    onTap: () {
                      // if (valid) {
                      //   context.read<NewChatCubit>().nextPage();
                      // }
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
