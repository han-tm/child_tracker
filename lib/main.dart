import 'dart:io';

import 'package:child_tracker/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:reactive_forms/reactive_forms.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // initializeDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('ru', 'RU')],
        debugShowCheckedModeBanner: false,
        home: MyWidget(),
      ),
    );
  });
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  FormGroup form = FormGroup({
    "phone": FormControl<String>(validators: [Validators.required]),
  });

  List<File> files = [];

  void onAdd(File file) => setState(() => files.add(file));

  void onDelete(File file) => setState(() => files.remove(file));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyscale50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          // FilledAppButton(text: 'Continue', onTap: (){
          //    _showIconModalBottomSheet(context);
          // }),

          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: () async {
              final r = await  showConfirmModalBottomSheet(context);
              print(r);
              
            },
            child: const Text('Показать модальное окно'),
          ),
        ],
      ),
    );
  }
}
