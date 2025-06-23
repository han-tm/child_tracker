import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BonusCard extends StatelessWidget {
  final BonusModel bonus;
  const BonusCard({super.key, required this.bonus});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CachedClickableImage(
                circularRadius: 12,
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: bonus.title,
                            size: 20,
                            fw: FontWeight.w700,
                          ),
                        ),
                        if (bonus.status == BonusStatus.received)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: success,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          child: LinearProgressIndicator(
                            value: 0.4,
                            color: success,
                            borderRadius: BorderRadius.circular(100),
                            backgroundColor: greyscale200,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const AppText(
                          text: '50 / 350 баллов',
                          size: 14,
                          fw: FontWeight.normal,
                          color: greyscale700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const AppText(
                      text: 'Ребёнок: Анастасия (создал)',
                      size: 12,
                      fw: FontWeight.normal,
                      color: greyscale700,
                    ),
                    const SizedBox(height: 4),
                    const AppText(
                      text: 'Наставник: Иван',
                      size: 12,
                      fw: FontWeight.normal,
                      color: greyscale700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 24,
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF8F3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:  AppText(text: 'readyToReceive'.tr(), size: 10, color: success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
