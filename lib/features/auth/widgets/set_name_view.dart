import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SetNameView extends StatelessWidget {
  const SetNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FillDataCubit, FillDataState>(
      builder: (context, state) {
        final isKid = state.userType == UserType.kid;
        return ReactiveForm(
          formGroup: FormGroup({
            'name': FormControl<String>(
              value: state.name,
              validators: [
                Validators.required,
                Validators.minLength(3),
                Validators.maxLength(60),
                Validators.pattern(r'^[a-zA-Zа-яА-ЯёЁ\s]+$'),
              ],
            ),
          }),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MaskotMessage(
                  message: isKid
                      ? 'Как тебя зовут? Я хочу запомнить твоё имя!'
                      : 'Как мне к тебе обращаться? Имя очень важно!',
                  maskot: isKid ? '2188-min' : '2186-min',
                  flip: true,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ReactiveCustomInput(
                  formName: 'name',
                  label: 'Имя',
                  hint: 'Введите имя',
                  inputType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  maxLenght: 60,
                  validationMessages: {
                    'required': (error) => 'Заполните поле',
                    'minLength': (error) => 'Минимум 3 символа',
                    'maxLength': (error) => 'Максимум 60 символов',
                    'pattern': (error) => 'Недопустимые символы',
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
                            text: 'Далее',
                            isActive: valid,
                            onTap: () {
                              if (valid) {
                                context.read<FillDataCubit>().onChangeName(formGroup.control('name').value);
                                context.read<FillDataCubit>().nextPage();
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
        );
      },
    );
  }
}
