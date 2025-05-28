import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class KidSignupSuccessScreen extends StatelessWidget {
  const KidSignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Image.asset(
                    'assets/images/2179-min.png',
                    fit: BoxFit.contain,
                    width: 280,
                  ),
                  const SizedBox(height: 16),
                  const AppText(
                    text: 'Ваш аккаунт готов!',
                    size: 32,
                    fw: FontWeight.w700,
                    color: primary900,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const AppText(
                    text: 'Давайте начнем ваш путь в нашем приложении!',
                    size: 16,
                    fw: FontWeight.w400,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FilledAppButton(
                    text: 'Начать',
                    onTap: () {
                      context.read<FillDataCubit>().reset();
                      context.go('/kid_bonus');
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
