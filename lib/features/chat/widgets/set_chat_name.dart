import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SetChatName extends StatelessWidget {
  const SetChatName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewChatCubit, NewChatState>(
      builder: (context, state) {
        return ReactiveForm(
          formGroup: FormGroup({
            'name': FormControl<String>(
              value: state.name,
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
                            text: 'Далее',
                            isActive: valid,
                            isLoading: state.status == NewChatStatus.loading,
                            onTap: () {
                              if (valid) {
                                if(state.status == NewChatStatus.loading) return;
                                context.read<NewChatCubit>().onChangeName(formGroup.control('name').value);
                                context.read<NewChatCubit>().nextPage();
                              } else {
                                formGroup.markAllAsTouched();
                                print(formGroup.errors);
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
