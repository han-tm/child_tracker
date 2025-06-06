import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class KidTaskEditNameScreen extends StatefulWidget {
  const KidTaskEditNameScreen({super.key});

  @override
  State<KidTaskEditNameScreen> createState() => _KidTaskEditNameScreenState();
}

class _KidTaskEditNameScreenState extends State<KidTaskEditNameScreen> {
  final form = FormGroup({
    'name': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(120),
      ],
    ),
    'description': FormControl<String>(),
  });

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    final state = context.read<KidTaskEditCubit>().state;
    form.value = {
      'name': state.name,
      'description': state.description,
    };
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: BlocBuilder<KidTaskEditCubit, KidTaskEditState>(
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
                      child: ReactiveForm(
                        formGroup: form,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: MaskotMessage(
                                message: 'Как назовём\nзадание?',
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
                                textInputAction: TextInputAction.next,
                                maxLenght: 120,
                                validationMessages: {
                                  'required': (error) => 'Заполните поле',
                                  'minLength': (error) => 'Минимум 3 символа',
                                  'maxLength': (error) => 'Максимум 120 символов',
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: ReactiveCustomInput(
                                formName: 'description',
                                label: 'Описание (опц.)',
                                hint: 'Введите описание',
                                inputType: TextInputType.multiline,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.newline,
                                minLines: 4,
                                maxLines: 5,
                                maxLenght: 500,
                                validationMessages: {
                                  'minLength': (error) => 'Минимум 3 символа',
                                  'maxLength': (error) => 'Максимум 500 символов',
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
                                          text: 'Применить',
                                          isActive: valid,
                                          onTap: () {
                                            formGroup.markAllAsTouched();
                                            if (valid) {
                                              final name = formGroup.control('name').value;
                                              final desc = formGroup.control('description').value;
                                              context.read<KidTaskEditCubit>().onChangeNameAndDescription(name, desc);
                                              context.pop();
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
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
