import 'package:flutter_riverpod/legacy.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/models/overtime_draft.dart';
import 'package:laravel_flutter/repository/overtime_repository.dart';

final overtimeDraftListProvider =
    StateNotifierProvider<OvertimeDraftNotifier, List<OvertimeDraft>>(
      (ref) => OvertimeDraftNotifier(),
    );

class OvertimeDraftNotifier extends StateNotifier<List<OvertimeDraft>> {
  OvertimeDraftNotifier() : super([]) {
    loadDrafts();
  }

  final _repo = OvertimeDraftRepository();

  // ================= LOAD =================

  Future<void> loadDrafts() async {
    state = await _repo.getAllDrafts();
  }

  // ================= CREATE =================

  Future<void> createDraft({required JobCategory category}) async {
    final draft = await _repo.createDraft(category: category);

    state = [draft, ...state];
  }

  // ================= UPDATE =================

  Future<void> updateDraftTimes({
    required String id,
    required String startTime,
    required String endTime,
  }) async {
    await _repo.updateDraftTimes(
      id: id,
      startTime: startTime,
      endTime: endTime,
    );

    state = state.map((draft) {
      if (draft.id == id) {
        return draft.copyWith(startTime: startTime, endTime: endTime);
      }
      return draft;
    }).toList();
  }

  Future<void> updateDraftDescription({
    required String id,
    String? description,
  }) async {
    await _repo.updateDraftDescription(id: id, description: description);

    state = state.map((draft) {
      if (draft.id == id) {
        return draft.copyWith(description: description);
      }
      return draft;
    }).toList();
  }

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

  // ================= DELETE =================

  Future<void> deleteDraft(String id) async {
    await _repo.deleteDraft(id);
    state = state.where((d) => d.id != id).toList();
  }

  Future<void> clearDrafts() async {
    await _repo.clearAllDrafts();
    state = [];
  }
}
