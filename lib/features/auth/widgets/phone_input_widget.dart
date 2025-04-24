import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  });

  var phoneFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void onTap() {
    FocusManager.instance.primaryFocus?.unfocus();
    final phone = '+7${phoneFormatter.getUnmaskedText()}';
    context.read<PhoneAuthCubit>().sendOTP(phone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveCustomInput(
                  formName: 'phone',
                  label: 'Номер телефона',
                  hint: 'Введите номер',
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, phoneFormatter],
                  inputType: TextInputType.number,
                  validationMessages: {
                    'required': (error) => 'Заполните номер телефона',
                    'invalid': (error) => 'Некорректный номер телефона',
                    'unique': (error) => 'Телефон уже зарегистрирован',
                  },
                ),
                if (state is PhoneAuthFailure)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RobotoText(text: state.errorMessage, color: appRed),
                  ),
                const SizedBox(height: 30),
                ReactiveFormConsumer(
                  builder: (context, formGroup, child) {
                    final valid = formGroup.valid && phoneFormatter.isFill();
                    return FilledAppButton(
                      onPress: valid ? onTap : null,
                      isActive: valid,
                      text: 'Отправить код',
                      isLoading: state is PhoneAuthLoading,
                    );
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    context.read<PhoneAuthCubit>().testEnter();
                  },
                  child: const Text('Test Enter'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
