// ignore_for_file: deprecated_member_use

import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TakeSubscriptionPlanScreen extends StatelessWidget {
  const TakeSubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMMM yyyy', 'ru_RU').format(DateTime.now().add(const Duration(days: 30)));
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 36),
                  CircleAvatar(
                    radius: 47,
                    backgroundColor: orange,
                    child: SvgPicture.asset('assets/images/crown.svg'),
                  ),
                  const SizedBox(height: 24),
                  const AppText(
                    text: 'Бесплатный период',
                    size: 32,
                    fw: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const AppText(
                    text:
                        'Вы получаете бесплатный доступ на 30 дней. После этого для продолжения использования приложения необходимо оформить подписку',
                    size: 16,
                    fw: FontWeight.normal,
                    textAlign: TextAlign.center,
                    maxLine: 5,
                  ),
                  const Divider(height: 48, thickness: 1, color: greyscale200),
                  const AppText(
                    text: 'Воспользуйтесь всеми функциями',
                    size: 24,
                    fw: FontWeight.w700,
                    textAlign: TextAlign.center,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/checkmark.svg',
                        width: 24,
                        color: greyscale900,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: AppText(
                          text: 'Следите за прогрессом',
                          size: 16,
                          fw: FontWeight.w500,
                          maxLine: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/checkmark.svg',
                        width: 24,
                        color: greyscale900,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: AppText(
                          text: 'Настраивайте цели и награды',
                          size: 16,
                          fw: FontWeight.w500,
                          maxLine: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/checkmark.svg',
                        width: 24,
                        color: greyscale900,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: AppText(
                          text: 'Подбирайте обучающие мини-игры и активности для ребёнка',
                          size: 16,
                          fw: FontWeight.w500,
                          maxLine: 2,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 48, thickness: 1, color: greyscale200),
                  AppText(
                    text: 'Срок действия истекает\n$date г.',
                    size: 18,
                    fw: FontWeight.w500,
                    maxLine: 2,
                    color: greyscale800,
                    textAlign: TextAlign.center,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Продлите подписку',
                        size: 16,
                        fw: FontWeight.w500,
                        maxLine: 1,
                        color: greyscale800,
                      ),
                      AppText(
                        text: ' здесь',
                        size: 18,
                        fw: FontWeight.w700,
                        color: primary900,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                    text: 'Начать использование',
                    onTap: () {
                      context.read<FillDataCubit>().reset();
                      context.go('/mentor_bonus');
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
