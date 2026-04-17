import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

class AuthService {
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('isMale');
  }

  static Future<String?> register(
    String u,
    String e,
    String p,
    bool isMale,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseHelper.database;
    final genderKey = isMale ? "boy" : "girl";
    final accountKey = 'user_${e}_${genderKey}';

    final oppositeKey = 'user_${e}_${isMale ? "girl" : "boy"}_pass';
    if (prefs.containsKey(oppositeKey)) {
      return "This account already exists in the ${isMale ? "girl" : "boy"} side.";
    }

    final existing = await db.query(
      'USER',
      where: 'Email = ? AND isMale = ?',
      whereArgs: [e, isMale ? 1 : 0],
    );
    if (existing.isNotEmpty) {
      return "This account already exists in the ${isMale ? "boy" : "girl"} side.";
    }

    String joinDate = DateTime.now().toString().split(' ')[0];
    await prefs.setString('${accountKey}_name', u);
    await prefs.setString('${accountKey}_pass', p);
    await prefs.setString('${accountKey}_joined', joinDate);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', e);
    await prefs.setString('username', u);
    await prefs.setBool('isMale', isMale);

    await db.insert('USER', {
      'Username': u,
      'Email': e,
      'Password': p,
      'isMale': isMale ? 1 : 0,
      'JoinDate': joinDate,
    });

    return null;
  }

  static Future<bool> login(
    String e,
    String p,
    bool currentSelectionIsMale,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseHelper.database;
    final genderKey = currentSelectionIsMale ? "boy" : "girl";
    final accountKey = 'user_${e}_${genderKey}';

    String? savedPass = prefs.getString('${accountKey}_pass');
    String? savedName = prefs.getString('${accountKey}_name');

    if (savedPass != null && savedPass == p) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', e);
      await prefs.setString('username', savedName ?? "");
      await prefs.setBool('isMale', currentSelectionIsMale);
      return true;
    }

    final result = await db.query(
      'USER',
      where: 'Email = ? AND Password = ? AND isMale = ?',
      whereArgs: [e, p, currentSelectionIsMale ? 1 : 0],
    );

    return result.isNotEmpty;
  }
}
