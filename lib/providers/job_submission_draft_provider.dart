import 'package:flutter_riverpod/legacy.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/models/job_submission_draft.dart';
import 'package:laravel_flutter/repository/job_submission_repository.dart';

final draftListProvider =
    StateNotifierProvider<DraftNotifier, List<JobSubmissionDraft>>(
      (ref) => DraftNotifier(),
    );

class DraftNotifier extends StateNotifier<List<JobSubmissionDraft>> {
  DraftNotifier() : super([]) {
    loadDrafts();
  }

  final _repo = JobSubmissionDraftRepository();

  Future<void> loadDrafts() async {
    state = await _repo.getAllDrafts();
  }

  /// ✏️ UPDATE IMAGE
  Future<void> updateDraftImages({
    required String id,
    String? beforePath,
    String? afterPath,
  }) async {
    await _repo.updateDraftImages(
      id: id,
      beforePath: beforePath,
      afterPath: afterPath,
    );

    // 🔥 update local state
    state = state.map((draft) {
      if (draft.id == id) {
        return draft.copyWith(
          beforeImagePath: beforePath ?? draft.beforeImagePath,
          afterImagePath: afterPath ?? draft.afterImagePath,
        );
      }
      return draft;
    }).toList();
  }

  Future<void> createDraft(JobCategory category) async {
    final draft = await _repo.createDraft(category);
    state = [draft, ...state];
  }

  /// 🗑 DELETE
  Future<void> deleteDraft(String id) async {
    await _repo.deleteDraft(id);
    state = state.where((d) => d.id != id).toList();
  }
}
