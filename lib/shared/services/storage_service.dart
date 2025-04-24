// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences prefs;

  StorageService({required this.prefs});

  final String ONBOARDSHOW = 'ONBOARDSHOW';

  bool isOnboardShowed() {
    return prefs.getBool(ONBOARDSHOW) ?? false;
  }

  Future<void> setOnboardStatus(bool status) async {
    await prefs.setBool(ONBOARDSHOW, status);
  }

  Future<bool> clearAllStorage() async {
    return await prefs.clear();
  }
}
