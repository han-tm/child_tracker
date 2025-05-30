import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewChatSuccessCreateScreen extends StatelessWidget {
  final DocumentReference ref;
  const NewChatSuccessCreateScreen({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/images/2184-min.png',
                      fit: BoxFit.contain,
                      width: 260,
                    ),
                    const SizedBox(height: 20),
                    const AppText(
                      text: 'Чат создан!',
                      size: 32,
                      fw: FontWeight.w700,
                      color: primary900,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const AppText(
                      text: 'Жми "Ок" — и начнём приятный разговор!',
                      size: 16,
                      fw: FontWeight.normal,
                      color: greyscale800,
                      textAlign: TextAlign.center,
                      maxLine: 2,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    FilledAppButton(
                        text: 'Ок',
                        onTap: () {
                          context.replace('/chat_room', extra: ref);
                        }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
