import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';
import 'database_helper.dart';

class DiaryService {
  static Future<void> saveEntries(
    List<DiaryEntry> entries,
    String email,
    bool isMale,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseHelper.database;
    String genderSuffix = isMale ? "_boy" : "_girl";
    String data = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString('entries_$email$genderSuffix', data);

    await db.delete(
      'DIARY_ENTRY',
      where: 'userEmail = ? AND isMale = ?',
      whereArgs: [email, isMale ? 1 : 0],
    );
    for (var entry in entries) {
      await db.insert('DIARY_ENTRY', entry.toDbMap(email, isMale));
    }

    for (var entry in entries) {
      await db.insert('DIARY_ENTRY', {
        'userEmail': email,
        'isMale': isMale ? 1 : 0,
        'Title': entry.title,
        'Content': entry.content,
        'Date': entry.date,
        'Happy': entry.happy,
        'Sad': entry.sad,
        'Anxious': entry.anxious,
        'Angry': entry.angry,
        'DisplayIndex': entry.displayIndex,
      });
    }
  }

  static Future<List<DiaryEntry>> loadEntries(String email, bool isMale) async {
    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseHelper.database;
    String genderSuffix = isMale ? "_boy" : "_girl";
    String? data = prefs.getString('entries_$email$genderSuffix');
    List<DiaryEntry> entries = [];
    if (data != null) {
      Iterable list = jsonDecode(data);
      return list.map((e) => DiaryEntry.fromJson(e)).toList();
    }
    final result = await db.query(
      'DIARY_ENTRY',
      where: 'userEmail = ? AND isMale = ?',
      whereArgs: [email, isMale ? 1 : 0],
    );

    final dbEntries = result.map((e) => DiaryEntry.fromMap(e)).toList();

    return [...entries, ...dbEntries];
  }
}
