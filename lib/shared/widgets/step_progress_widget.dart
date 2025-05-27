import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class StepProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const StepProgressWidget({
    super.key,
    this.currentStep = 0,
    this.totalSteps = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: (currentStep) / totalSteps,
            backgroundColor: greyscale200,
            color: primary900,
            minHeight: 12,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 30),
        AppText(
          text: '0${currentStep + 1}/0$totalSteps',
          size: 20,
        ),
      ],
    );
  }
}
