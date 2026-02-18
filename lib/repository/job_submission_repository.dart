import 'package:laravel_flutter/sqlite/local_database.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/models/job_submission_draft.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';

final ValueNotifier<int> draftCountNotifier = ValueNotifier<int>(0);

class JobSubmissionDraftRepository {
  final _uuid = const Uuid();

  Future<JobSubmissionDraft> createDraft(JobCategory category) async {
    final db = await LocalDatabase.database;

    final draft = JobSubmissionDraft(
      id: _uuid.v4(),
      categoryId: category.id,
      categoryName: category.name,
      createdAt: DateTime.now(),
    );

    await db.insert('job_submission_drafts', draft.toMap());
    return draft;
  }

  Future<List<JobSubmissionDraft>> getAllDrafts() async {
    final db = await LocalDatabase.database;
    final result = await db.query(
      'job_submission_drafts',
      orderBy: 'created_at DESC',
    );

    return result.map(JobSubmissionDraft.fromMap).toList();
  }

  Future<void> updateDraftImages({
    required String id,
    String? beforePath,
    String? afterPath,
  }) async {
    final db = await LocalDatabase.database;

    await db.update(
      'job_submission_drafts',
      {
        if (beforePath != null) 'before_image_path': beforePath,
        if (afterPath != null) 'after_image_path': afterPath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getDraftCount() async {
    final db = await LocalDatabase.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM job_submission_drafts',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteDraft(String id) async {
    final db = await LocalDatabase.database;
    await db.delete('job_submission_drafts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllDrafts() async {
    final db = await LocalDatabase.database;
    await db.delete('job_submission_drafts');
  }
}
