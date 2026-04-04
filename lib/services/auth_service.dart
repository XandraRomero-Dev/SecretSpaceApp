import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<void> register(
    String u,
    String e,
    String p,
    bool isMale,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String joinDate = DateTime.now().toString().split(' ')[0];
    await prefs.setString('user_${e}_name', u);
    await prefs.setString('user_${e}_pass', p);
    await prefs.setBool('user_${e}_isMale', isMale);
    await prefs.setString('user_${e}_joined', joinDate);

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', e);
    await prefs.setString('username', u);
  }

  static Future<bool> login(
    String e,
    String p,
    bool currentSelectionIsMale,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedPass = prefs.getString('user_${e}_pass');
    bool? savedIsMale = prefs.getBool('user_${e}_isMale');

    if (savedPass == p && savedIsMale == currentSelectionIsMale) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', e);
      await prefs.setString(
        'username',
        prefs.getString('user_${e}_name') ?? "",
      );
      return true;
    }
    return false;
  }
}
