import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phone = '';
  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => PhoneAuthCubit(userCubit: sl()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: const AppText(text: 'Вход', color: greyscale900),
          centerTitle: true,
        ),
        body: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
          listener: (context, state) {
            if (state is PhoneAuthFailure) {
              SnackBarSerive.showErrorSnackBar('Ошибка: ${state.errorMessage}');
            } else if (state is PhoneAuthCodeAutoRetrievalTimeout) {
              SnackBarSerive.showErrorSnackBar('Время ожидания OTP истекло. Пожалуйста, запросите код заново.');
            }else if(state is PhoneAuthSuccess){
              context.go('/kid/bonus');
            }
          },
          builder: (context, state) {
            if(state is PhoneAuthInitial || state is PhoneAuthFailure) return const PhoneInputWidget();
            if(state is PhoneAuthCodeSentSuccess || state is PhoneAuthCodeAutoRetrievalTimeout || state is PhoneAuthResendOTPSuccess) return const PhoneInputWidget();
            // if (state is PhoneAuthLoading) {
            //   return Center(child: CircularProgressIndicator());
            // } else if (state is PhoneAuthInitial || state is PhoneAuthFailure) {
            //   return Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         TextField(
            //           // controller: _phoneNumberController,
            //           keyboardType: TextInputType.phone,
            //           decoration: InputDecoration(labelText: 'Номер телефона'),
            //         ),
            //         SizedBox(height: 20),
            //         ElevatedButton(
            //           onPressed: () {
            //             // BlocProvider.of<PhoneAuthCubit>(context)
            //             //     .sendOTP('+993${_phoneNumberController.text}'); // Пример для Туркменистана
            //           },
            //           child: Text('Отправить OTP'),
            //         ),
            //         if (state is PhoneAuthFailure)
            //           Padding(
            //             padding: const EdgeInsets.only(top: 10.0),
            //             child: Text(state.errorMessage, style: TextStyle(color: Colors.red)),
            //           ),
            //       ],
            //     ),
            //   );
            // } else if (state is PhoneAuthCodeSentSuccess ||
            //     state is PhoneAuthCodeAutoRetrievalTimeout ||
            //     state is PhoneAuthResendOTPSuccess) {
            //   return Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         TextField(
            //           keyboardType: TextInputType.number,
            //           decoration: InputDecoration(labelText: 'Код подтверждения'),
            //         ),
            //         SizedBox(height: 20),
            //         ElevatedButton(
            //           onPressed: () {
            //             // BlocProvider.of<PhoneAuthCubit>(context).verifyOTP(_otpController.text);
            //           },
            //           child: Text('Подтвердить OTP'),
            //         ),
            //         SizedBox(height: 10),
            //         TextButton(
            //           onPressed: state is PhoneAuthLoading
            //               ? null
            //               : () {
            //                   BlocProvider.of<PhoneAuthCubit>(context).resendOTP();
            //                 },
            //           child: Text('Отправить код повторно'),
            //         ),
            //       ],
            //     ),
            //   );
            // }
            return Container(); // Default case
          },
        ),
      ),
    );
  }
}
