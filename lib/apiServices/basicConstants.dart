// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class BasicConstants {
  static SharedPreferences? prefs;
  static const String USER_NAME = 'user_name';
  static const String PROFILE_URL = 'profile_url';
  static const String USER_ID = 'user_id';
  static const String PLAN_ID = 'plan_id';
  static const String ALL_CATS = 'all_cats';
  static const String ALREADY_APPLIED = 'already_applied';
  static const String IS_PROFILE = 'is_profile';
  static const String IS_PREMiUM_USER = 'is_premium_user';
  static const String IS_FREE_USER = 'is_free_user';
  static const String PASSPORT_URL = 'passport_url';

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}
