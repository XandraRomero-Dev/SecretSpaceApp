import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'secretspace.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE USER (
            UserID INTEGER PRIMARY KEY AUTOINCREMENT,
            Username TEXT NOT NULL,
            Email TEXT UNIQUE NOT NULL,
            Password TEXT NOT NULL,
            isMale INTEGER,
            JoinDate TEXT DEFAULT (CURRENT_DATE)
          )
        ''');

        await db.execute('''
          CREATE TABLE USER_SETTINGS (
            SettingID INTEGER PRIMARY KEY AUTOINCREMENT,
            UserID INTEGER UNIQUE,
            PrimaryColor TEXT,
            BackgroundColor TEXT,
            TextColor TEXT,
            FOREIGN KEY (UserID) REFERENCES USER(UserID) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE DIARY_ENTRY (
            EntryID INTEGER PRIMARY KEY AUTOINCREMENT,
            userEmail TEXT,
            isMale INTEGER,
            Title TEXT,
            Content TEXT,
            Date TEXT,
            Happy INTEGER DEFAULT 0,
            Sad INTEGER DEFAULT 0,
            Anxious INTEGER DEFAULT 0,
            Angry INTEGER DEFAULT 0,
            DisplayIndex INTEGER
          )
        ''');
      },
    );
  }
}
