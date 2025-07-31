import 'dart:io';

import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EditBonusScreen extends StatelessWidget {
  final BonusModel bonus;
  const EditBonusScreen({super.key, required this.bonus});

  void onChangeMode(BuildContext context, String path) {
    context.push('/edit_bonus/$path', extra: bonus);
  }

  void onDelete(BuildContext context) async {
    // final confrim = await showConfirmModalBottomSheet(
    //   context,
    //   title: 'delete'.tr(),
    //   isDestructive: true,
    //   cancelText: 'cancel'.tr(),
    //   confirmText: 'yesDelete'.tr(),
    //   message: 'are_you_sure_delete'.tr(),
    // );
    // if (confrim == true && context.mounted) {
    //   final result = await context.read<TaskCubit>().deleteTask(task);
    //   if (result && context.mounted) {
    //     context.replace('/task_delete_success');
    //   } else {
    //     SnackBarSerive.showErrorSnackBar('failed_to_delete_task'.tr());
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<EditBonusCubit, EditBonusState>(
        listener: (context, state) {
          if (state.status == EditBonusStatus.error) {
            SnackBarSerive.showErrorSnackBar(state.errorMessage ?? defaultErrorText);
          } else if (state.status == EditBonusStatus.success) {
            SnackBarSerive.showSuccessSnackBar('task_updated'.tr());
            context.pop(true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              leadingWidth: 70,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.arrow_left),
                onPressed: () {
                  context.pop();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/delete.svg',
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                    onPressed: () => onDelete(context),
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(
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
                                message: 'want_to_fix_something'.tr(),
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
                                            onTap: () => onChangeMode(context, 'photo'),
                                            imageUrl:
                                                (state.photo == null && state.emoji == null) ? state.photoUrl : null,
                                            imageFile: state.photo != null ? File(state.photo!.path) : null,
                                            emoji: state.emoji,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: GestureDetector(
                                              onTap: () => onChangeMode(context, 'photo'),
                                              child: SvgPicture.asset('assets/images/edit_blue_fill.svg'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () => onChangeMode(context, 'name'),
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
                                      text: 'apply'.tr(),
                                      isLoading: state.status == EditBonusStatus.loading,
                                      onTap: () {
                                        if (state.status == EditBonusStatus.loading) return;
                                        context.read<EditBonusCubit>().editBonus();
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
            ),
          );
        },
      );
    });
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
