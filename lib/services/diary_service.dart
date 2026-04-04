import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';

class DiaryService {
  static Future<void> saveEntries(
    List<DiaryEntry> entries,
    String email,
    bool isMale,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String genderSuffix = isMale ? "_boy" : "_girl";
    String data = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString('entries_${email}$genderSuffix', data);
  }

  static Future<List<DiaryEntry>> loadEntries(String email, bool isMale) async {
    final prefs = await SharedPreferences.getInstance();
    String genderSuffix = isMale ? "_boy" : "_girl";
    String? data = prefs.getString('entries_${email}$genderSuffix');
    if (data != null) {
      Iterable list = jsonDecode(data);
      return list.map((e) => DiaryEntry.fromJson(e)).toList();
    }
    return [];
  }
}
