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
    final path = join(dir.path, 'job_submission.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
      },
    );
  }
}
