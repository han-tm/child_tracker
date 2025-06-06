import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTaskSuccessScreen extends StatelessWidget {
  const CreateTaskSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BottomArrowBubleShape(
                  child: AppText(
                    text: 'Ура!',
                    size: 24,
                    fw: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/2184-min.png',
                  fit: BoxFit.contain,
                  width: 240,
                ),
                const SizedBox(height: 16),
                const AppText(
                  text: 'Задание создано!',
                  size: 32,
                  fw: FontWeight.w700,
                  color: primary900,
                ),
                const SizedBox(height: 10),
                const AppText(
                  text: 'Я прослежу, чтобы всё было выполнено',
                  size: 16,
                  fw: FontWeight.w400,
                  color: greyscale800,
                ),
              ],
            ),
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
                    text: 'Ок',
                    onTap: () {
                      context.pop();
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
