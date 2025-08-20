import 'package:child_tracker/app.dart';
import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:telegram_web_app/telegram_web_app.dart' hide DeviceOrientation;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    if (TelegramWebApp.instance.isSupported) {
      TelegramWebApp.instance.ready();
      Future.delayed(const Duration(seconds: 1), TelegramWebApp.instance.expand);
    }
  } catch (e) {
    print("Error happened in Flutter while loading Telegram $e");
    await Future.delayed(const Duration(milliseconds: 200));
    main();
    return;
  }

  FlutterError.onError = (details) {
    print("Flutter error happened: $details");
  };

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCtVxKE51wDXG8v6o0iXwuYSGwjOqsA1nM",
      authDomain: "kidscult-a5d7e.firebaseapp.com",
      projectId: "kidscult-a5d7e",
      storageBucket: "kidscult-a5d7e.firebasestorage.app",
      messagingSenderId: "419315761443",
      appId: "1:419315761443:web:e2fc3c88681cde33b78c96",
      measurementId: "G-RE21HL6CHJ",
    ),
  );

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // if (kIsWeb) {
  //   await messaging.getToken(
  //     vapidKey: "BOd6pz993_wS2RpMsFrMzO-iINEdFK4cPXHQaEvVflpzViV8SRFzIgAjRjtmUTWlRAPlIQUMoZW-zreFc5TxfCQ",
  //   );
  // }

  await initializeDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    final localeCubit = sl<LocaleCubit>();
    await localeCubit.initCurrentLocale();

    runApp(EasyLocalization(
      supportedLocales: LocaleCubit.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      startLocale: localeCubit.state,
      useOnlyLangCode: true,
      child: BlocProvider.value(
        value: localeCubit,
        child: const App(),
      ),
    ));
  });

  
}

