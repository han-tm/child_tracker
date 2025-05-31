import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditChatNameScreen extends StatefulWidget {
  final ChatModel chat;
  const EditChatNameScreen({super.key, required this.chat});

  @override
  State<EditChatNameScreen> createState() => _EditChatNameScreenState();
}

class _EditChatNameScreenState extends State<EditChatNameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const AppText(
          text: 'Название чата',
          size: 24,
          fw: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: ReactiveForm(
        formGroup: FormGroup({
          'name': FormControl<String>(
            value: widget.chat.name,
            validators: [
              Validators.required,
              Validators.minLength(3),
              Validators.maxLength(60),
            ],
          ),
        }),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: MaskotMessage(
                message: 'Как назовём\nчат?',
                maskot: '2186-min',
                flip: true,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ReactiveCustomInput(
                formName: 'name',
                label: 'Название',
                hint: 'Введите название',
                inputType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                maxLenght: 60,
                validationMessages: {
                  'required': (error) => 'Заполните поле',
                  'minLength': (error) => 'Минимум 3 символа',
                  'maxLength': (error) => 'Максимум 60 символов',
                },
              ),
            ),
            const Spacer(),
            ReactiveFormConsumer(
              builder: (context, formGroup, child) {
                final valid = formGroup.valid;
                return Container(
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FilledAppButton(
                          text: 'Сохранить',
                          isActive: valid,
                          onTap: () async {
                            if (valid) {
                              await widget.chat.ref.update({'name': formGroup.control('name').value});
                              if (mounted) {
                                setState(() {
                                  widget.chat.name = formGroup.control('name').value;
                                });

                                SnackBarSerive.showSuccessSnackBar('Название обновлено');
                                if (context.mounted) context.pop();
                              }
                            } else {
                              formGroup.markAllAsTouched();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
