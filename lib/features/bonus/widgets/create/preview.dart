import 'dart:io';

import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateBonusPreview extends StatelessWidget {
  const CreateBonusPreview({super.key});

  void onChangeMode(BuildContext context, int index) {
    context.read<CreateBonusCubit>().onChangeMode(true);
    context.read<CreateBonusCubit>().onJumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBonusCubit, CreateBonusState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: MaskotMessage(
                            message: 'check_task_details_prompt'.tr(),
                            maskot: '2177-min',
                            flip: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: greyscale200, width: 3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CachedClickableImage(
                                        width: 100,
                                        height: 100,
                                        circularRadius: 300,
                                        emojiFontSize: 60,
                                        onTap: () => onChangeMode(context, 0),
                                        imageFile: state.photo != null ? File(state.photo!.path) : null,
                                        emoji: state.emoji,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () => onChangeMode(context, 0),
                                          child: SvgPicture.asset('assets/images/edit_blue_fill.svg'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () => onChangeMode(context, 1),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: AppText(
                                        text: state.name ?? '-',
                                        size: 24,
                                        fw: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    _leftArrow(),
                                  ],
                                ),
                              ),
                              if (state.link != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: AppText(
                                    text: state.link!.trim(),
                                    fw: FontWeight.normal,
                                    color: greyscale700,
                                    maxLine: 3,
                                  ),
                                ),
                              const Divider(height: 40, thickness: 1, color: greyscale200),
                            
                            
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        Container(
                          decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: FilledAppButton(
                                  text: 'create'.tr(),
                                  isLoading: state.status == CreateBonusStatus.loading,
                                  onTap: () {
                                    if (state.status == CreateBonusStatus.loading) return;
                                    context.read<CreateBonusCubit>().createBonus();
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _leftArrow() {
    return const SizedBox(
      width: 24,
      child: Align(
        alignment: Alignment.centerRight,
        child: Icon(
          CupertinoIcons.chevron_right,
          color: dark5,
          size: 20,
        ),
      ),
    );
  }
}
