import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await _auth.signOut();
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
    try {
      final prefs = await SharedPreferences.getInstance();

      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: e,
        password: p,
      );

      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(u);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', e);
        await prefs.setString('username', u);
        await prefs.setBool('isMale', isMale);
      }
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  static Future<bool> login(
    String e,
    String p,
    bool currentSelectionIsMale,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: e,
        password: p,
      );

      User? user = result.user;
      if (user != null) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', e);
        await prefs.setString('username', user.displayName ?? "");
        await prefs.setBool('isMale', currentSelectionIsMale);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
