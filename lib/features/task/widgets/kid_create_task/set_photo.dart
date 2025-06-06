import 'dart:io';

import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class KidCreateTaskSetPhoto extends StatelessWidget {
  const KidCreateTaskSetPhoto({super.key});

  void onPick(BuildContext context) async {
    final XFile? xfile = await CustomImagePicker.pickAvatarFromGallery(context);
    if (xfile != null && context.mounted) {
      context.read<KidTaskCreateCubit>().onChangePhoto(xfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KidTaskCreateCubit, KidTaskCreateState>(
      builder: (context, state) {
        final valid = state.photo != null || state.emoji != null;
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 34, right: 24),
              child: MaskotMessage(
                message: 'Добавим картинку?',
                maskot: '2177-min',
                flip: true,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  CachedClickableImage(
                    width: 100,
                    height: 100,
                    circularRadius: 300,
                    emojiFontSize: 60,
                    onTap: () => onPick(context),
                    imageFile: state.photo != null ? File(state.photo!.path) : null,
                    emoji: state.emoji,
                    noImageWidget: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        border: Border.all(color: greyscale200, width: 2),
                      ),
                      child: const Center(
                        child: Icon(CupertinoIcons.add, size: 40, color: primary900),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: EmojiPicker(
                      onPick: (emoji) {
                        context.read<KidTaskCreateCubit>().onChangeEmoji(emoji);
                      },
                    ),
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
                      text: state.isEditMode ? 'Применить' : 'Далее',
                      isActive: valid,
                      onTap: () {
                        if (valid) {
                          if (state.isEditMode) {
                            context.read<KidTaskCreateCubit>().onChangeMode(false);
                            context.read<KidTaskCreateCubit>().onJumpToPage(5);
                          } else {
                            context.read<KidTaskCreateCubit>().nextPage();
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
