
import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<StorageService>(StorageService(prefs: prefs));

  final fs = FirebaseFirestore.instance;
  final fa = FirebaseAuth.instance;
  final fcm = FirebaseMessaging.instance;
  final ff = FirebaseFunctions.instance;

  print('$fa, $ff, $fcm');

  // //services
  // sl.registerLazySingleton(() => PhoneValidatorService(firestore: fs));
  // sl.registerLazySingleton(() => FirebaseStorageService());

  // Cubits
  sl.registerLazySingleton(() => UserCubit(fs: fs));
}
