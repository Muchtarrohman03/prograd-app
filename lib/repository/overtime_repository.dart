import 'package:flutter/material.dart';
import 'package:laravel_flutter/sqlite/local_database.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/models/overtime_draft.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

final ValueNotifier<int> overtimeDraftCountNotifier = ValueNotifier<int>(0);

class OvertimeDraftRepository {
  final _uuid = const Uuid();

  // ================= CREATE =================

  Future<OvertimeDraft> createDraft({required JobCategory category}) async {
    final db = await LocalDatabase.database;

    final draft = OvertimeDraft(
      id: _uuid.v4(),
      categoryId: category.id,
      categoryName: category.name,
      startTime: '00:00', // ⬅️ aman, NOT NULL
      endTime: '00:00', // ⬅️ aman
      description: null,
      beforeImagePath: 'placeholder', // ⬅️ wajib ada
      afterImagePath: null,
      createdAt: DateTime.now(),
    );

    await db.insert('overtime_drafts', draft.toMap());
    await _updateDraftCount();

    return draft;
  }

  // ================= READ =================

  Future<List<OvertimeDraft>> getAllDrafts() async {
    final db = await LocalDatabase.database;

    final result = await db.query(
      'overtime_drafts',
      orderBy: 'created_at DESC',
    );

    return result.map(OvertimeDraft.fromMap).toList();
  }

  Future<OvertimeDraft?> getDraftById(String id) async {
    final db = await LocalDatabase.database;

    final result = await db.query(
      'overtime_drafts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return OvertimeDraft.fromMap(result.first);
  }

  // ================= UPDATE =================

  Future<void> updateDraftTimes({
    required String id,
    required String startTime,
    required String endTime,
  }) async {
    final db = await LocalDatabase.database;

    await db.update(
      'overtime_drafts',
      {'start_time': startTime, 'end_time': endTime},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDraftDescription({
    required String id,
    String? description,
  }) async {
    final db = await LocalDatabase.database;

    await db.update(
      'overtime_drafts',
      {'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDraftImages({
    required String id,
    String? beforePath,
    String? afterPath,
  }) async {
    final db = await LocalDatabase.database;

    await db.update(
      'overtime_drafts',
      {
        if (beforePath != null) 'before_image_path': beforePath,
        if (afterPath != null) 'after_image_path': afterPath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ================= DELETE =================

  Future<void> deleteDraft(String id) async {
    final db = await LocalDatabase.database;

    await db.delete('overtime_drafts', where: 'id = ?', whereArgs: [id]);

    await _updateDraftCount();
  }

  Future<void> clearAllDrafts() async {
    final db = await LocalDatabase.database;
    await db.delete('overtime_drafts');
    await _updateDraftCount();
  }

  // ================= UTILS =================

  Future<int> getDraftCount() async {
    final db = await LocalDatabase.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM overtime_drafts',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> _updateDraftCount() async {
    overtimeDraftCountNotifier.value = await getDraftCount();
  }

  Future<void> deletAllDrafts() async {
    final db = await LocalDatabase.database;
    await db.delete('overtime_drafts');
  }
}
