import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/diary_entry.dart';
import 'database_helper.dart';

class DiaryService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<String?> addEntry(
    DiaryEntry entry,
    String email,
    bool isMale,
  ) async {
    final genderKey = isMale ? "boy" : "girl";
    final collectionRef = _db
        .collection('users')
        .doc(email)
        .collection(genderKey);
    final docRef = await collectionRef.add({
      'title': entry.title,
      'content': entry.content,
      'date': entry.date,
      'happy': entry.happy,
      'sad': entry.sad,
      'anxious': entry.anxious,
      'angry': entry.angry,
      'displayIndex': entry.displayIndex,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  static Future<void> deleteEntry(
    String docId,
    String email,
    bool isMale,
  ) async {
    final genderKey = isMale ? "boy" : "girl";
    await _db
        .collection('users')
        .doc(email)
        .collection(genderKey)
        .doc(docId)
        .delete();
  }

  static Future<List<DiaryEntry>> loadEntries(String email, bool isMale) async {
    try {
      final genderKey = isMale ? "boy" : "girl";
      final snapshot = await _db
          .collection('users')
          .doc(email)
          .collection(genderKey)
          .orderBy('displayIndex')
          .get()
          .timeout(const Duration(seconds: 5));

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => DiaryEntry.fromMap(doc.data(), documentId: doc.id))
            .toList();
      }
    } catch (e) {
      print("Firestore load failed: $e");
    }

    final db = await DatabaseHelper.database;
    final result = await db.query(
      'DIARY_ENTRY',
      where: 'userEmail = ? AND isMale = ?',
      whereArgs: [email, isMale ? 1 : 0],
    );

    return result.map((e) => DiaryEntry.fromDbMap(e)).toList();
  }
}
