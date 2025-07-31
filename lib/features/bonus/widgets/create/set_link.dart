import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateBonusSetLink extends StatefulWidget {
  const CreateBonusSetLink({super.key});

  @override
  State<CreateBonusSetLink> createState() => _CreateBonusSetLinkState();
}

class _CreateBonusSetLinkState extends State<CreateBonusSetLink> {
  final form = FormGroup({
    'link': FormControl<String>(),
  });

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
                    child: ReactiveForm(
                      formGroup: form,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: MaskotMessage(
                              message: 'name_the_task_prompt'.tr(),
                              maskot: '2186-min',
                              flip: true,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ReactiveCustomInput(
                              formName: 'link',
                              label: 'title'.tr(),
                              hint: 'enter_title_hint'.tr(),
                              inputType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              maxLenght: 300,
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
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: FilledSecondaryAppButton(
                                              text: 'skip'.tr(),
                                              onTap: () {
                                                if (state.isEditMode) {
                                                  context.read<CreateBonusCubit>().onChangeMode(false);
                                                  context.read<CreateBonusCubit>().onJumpToPage(5);
                                                } else {
                                                  context.read<CreateBonusCubit>().nextPage();
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: FilledAppButton(
                                              text: state.isEditMode ? 'apply'.tr() : 'next'.tr(),
                                              isActive: valid,
                                              onTap: () {
                                                formGroup.markAllAsTouched();
                                                if (valid) {
                                                  final name = formGroup.control('name').value;
                                                  context.read<CreateBonusCubit>().onChangeName(name);
                                                  if (state.isEditMode) {
                                                    context.read<CreateBonusCubit>().onChangeMode(false);
                                                    context.read<CreateBonusCubit>().onJumpToPage(5);
                                                  } else {
                                                    context.read<CreateBonusCubit>().nextPage();
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ],
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
    );
  }
}
