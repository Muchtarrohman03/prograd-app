import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'draft.db');

    return openDatabase(
      path,
      version: 2, // ⬅️ NAIKKAN VERSION
      onCreate: (db, version) async {
        await _createJobSubmissionDrafts(db);
        await _createOvertimeDrafts(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createOvertimeDrafts(db);
        }
      },
    );
  }

  // ================= TABLE SCHEMAS =================

  static Future<void> _createJobSubmissionDrafts(Database db) async {
    await db.execute('''
      CREATE TABLE job_submission_drafts (
        id TEXT PRIMARY KEY,
        category_id INTEGER NOT NULL,
        category_name TEXT NOT NULL,
        before_image_path TEXT,
        after_image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _createOvertimeDrafts(Database db) async {
    await db.execute('''
      CREATE TABLE overtime_drafts (
        id TEXT PRIMARY KEY,
        category_id INTEGER NOT NULL,
        category_name TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        description TEXT,
        before_image_path TEXT NOT NULL,
        after_image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }
}
