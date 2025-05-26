import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class PhoneOtpInput extends StatelessWidget {
  final String phone;
  const PhoneOtpInput({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
      builder: (context, state) {
        String? errorText = state is PhoneAuthFailure ? state.errorMessage : null;
        return Column(
          children: [
            const AppText(
              text: 'Проверка телефона',
              textAlign: TextAlign.center,
              size: 24,
              fw: FontWeight.w500,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(text: 'На номер '),
                AppText(text: phone, color: primary900),
              ],
            ),
            const AppText(text: 'был отправлен код'),
            const SizedBox(height: 16),
            Pinput(
              length: 6,
              // onCompleted: (v) => onComplete(v, method),
              // onChanged: (value) {
              //   if (value.length != 6 && errorText != null) {
              //     setState(() {
              //       errorText = null;
              //     });
              //   }
              // },
              separatorBuilder: (index) => const SizedBox(width: 12),
              errorText: errorText,
              forceErrorState: errorText != null,

              errorBuilder: (errorText, pin) {
                if (errorText != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: AppText(
                          text: errorText,
                          color: red,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },

              enabled: state is! PhoneAuthLoading,
              defaultPinTheme: PinTheme(
                height: 54,
                width: 74,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: greyscale200),
                ),
              ),
              focusedPinTheme: PinTheme(
                height: 54,
                width: 74,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: primary900),
                ),
              ),
              followingPinTheme: PinTheme(
                height: 54,
                width: 74,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: greyscale200),
                ),
              ),
              submittedPinTheme: PinTheme(
                height: 54,
                width: 74,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: greyscale200),
                ),
              ),
              errorPinTheme: PinTheme(
                height: 54,
                width: 74,
                textStyle: const TextStyle(fontSize: 24, color: greyscale900, fontWeight: FontWeight.normal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: red),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // OtpTimer(onResend: () {
            //   context.read<AuthCubit>().setResendStatus(true);
            //   context.read<AuthCubit>().sendCode(phone, method);
            // }),
          ],
        );
      },
    );
  }
}
