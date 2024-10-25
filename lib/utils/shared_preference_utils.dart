import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserMobileNumber(String value) async {
    if (_prefs == null) await initialize();
    await _prefs.setString('MOBNO', value);
  }

  static String getUserMobileNumber() {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    return _prefs.getString('MOBNO') ?? '';
  }

  static Future<void> setFcmToken(String value) async {
    if (_prefs == null) await initialize();
    await _prefs.setString('FCMTOKEN', value);
  }

  static String getFcmToken() {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    return _prefs.getString('FCMTOKEN') ?? '';
  }

  static Future<void> setLoginToken(String value) async {
    if (_prefs == null) await initialize();
    await _prefs.setString('LOGINTOKEN', value);
  }

  static String getLoginToken() {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    return _prefs.getString('LOGINTOKEN') ?? '';
  }
  static Future<void> setLoginId(String value) async {
    if (_prefs == null) await initialize();
    await _prefs.setString('CID', value);
  }

  static String getLoginId() {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    return _prefs.getString('CID') ?? '';
  }

  static Future<void> setUserFullName(String value) async {
    if (_prefs == null) await initialize();
    await _prefs.setString('NAME', value);
  }

  static String getUserFullName() {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    return _prefs.getString('NAME') ?? '';
  }

  static Future<void> setIsLogin(bool value) async {
    if (_prefs == null) await initialize();
    await _prefs.setBool('LOGIN', value);
  }

  static bool getIsLogin() {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    return _prefs.getBool('LOGIN') ?? false;
  }

  static Future<void> clearLocalData() async {
    if (_prefs == null) await initialize();
    await _prefs.remove('UserMobileNumber');
    await _prefs.remove('fcmToken');
    await _prefs.remove('loginToken');
    await _prefs.remove('loginId');
    await _prefs.remove('UserFullName');
    await _prefs.remove('isLogin');
  }
}
