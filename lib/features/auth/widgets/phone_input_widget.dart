import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PhoneInputWidget extends StatefulWidget {
  const PhoneInputWidget({super.key});

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  final form = FormGroup({
    'phone': FormControl<String>(
      validators: [Validators.required],
    ),
    'privacy': FormControl<bool>(value: false, validators: [Validators.requiredTrue]),
  });

  var phoneFormatter = MaskTextInputFormatter(
    mask: '+###############',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void onTap() {
    if (form.valid) {
      FocusManager.instance.primaryFocus?.unfocus();
      final phone = '+${phoneFormatter.getUnmaskedText()}';
      context.read<PhoneAuthCubit>().sendOTP(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthCodeSentSuccess) {
          final phone = '+${phoneFormatter.getUnmaskedText()}';
          context.push('/auth/verify', extra: phone);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ReactiveForm(
            formGroup: form,
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom + 16.0
                          : 16.0,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: MaskotMessage(
                              message: 'Введите номер телефона!',
                              maskot: '2177-min',
                              flip: true,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ReactiveCustomInput(
                              formName: 'phone',
                              label: 'Номер телефона',
                              hint: 'Введите номер',
                              textInputAction: TextInputAction.done,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, phoneFormatter],
                              inputType: TextInputType.number,
                              validationMessages: {
                                'required': (error) => 'Заполните номер телефона',
                                'invalid': (error) => 'Некорректный номер телефона',
                              },
                            ),
                          ),
                          if (state is PhoneAuthFailure)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: CustomErrorWidget(errorText: state.errorMessage),
                            ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Padding(
                                  padding: EdgeInsets.only(left: 14, right: 24),
                                  child: CustomReactiveCheckbox(),
                                ),
                                const SizedBox(height: 24),
                                ReactiveFormConsumer(builder: (context, formGroup, child) {
                                  final valid = formGroup.valid;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: FilledAppButton(
                                      text: 'Далее',
                                      isActive: valid,
                                      onTap: onTap,
                                      isLoading: state is PhoneAuthLoading,
                                    ),
                                  );
                                }),
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
            }),
          ),
        );
      },
    );
  }
}
