import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_flutter/components/reusable/app_snackbar.dart';
import 'package:laravel_flutter/components/reusable/custom_image_picker.dart';
import 'package:laravel_flutter/components/reusable/custom_outlined_button.dart';
import 'package:laravel_flutter/components/reusable/custom_time_picker.dart';
import 'package:laravel_flutter/components/reusable/image_thumbnail.dart';
import 'package:laravel_flutter/helpers/dialog_helper.dart';
import 'package:laravel_flutter/helpers/time_helper.dart';
import 'package:laravel_flutter/models/overtime_draft.dart';
import 'package:laravel_flutter/providers/overtime_draft_provider.dart';
import 'package:laravel_flutter/services/api_service.dart';

class OvertimeDraftPage extends ConsumerStatefulWidget {
  const OvertimeDraftPage({super.key});

  @override
  ConsumerState<OvertimeDraftPage> createState() => _OvertimeDraftPageState();
}

class _OvertimeDraftPageState extends ConsumerState<OvertimeDraftPage> {
  final Map<String, File?> _beforeImages = {};
  final Map<String, File?> _afterImages = {};

  bool _isSaving = false;
  bool _isUploading = false;

  final Map<String, TimeOfDay> _startTimes = {};
  final Map<String, TimeOfDay> _endTimes = {};

  TimeOfDay _getStartTime(OvertimeDraft draft) {
    return _startTimes[draft.id] ?? draft.startAsTime ?? TimeOfDay.now();
  }

  TimeOfDay _getEndTime(OvertimeDraft draft) {
    return _endTimes[draft.id] ??
        draft.endAsTime ??
        const TimeOfDay(hour: 0, minute: 0);
  }

  Future<void> _captureBefore(String draftId) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      _beforeImages[draftId] = File(picked.path);
    });
  }

  Future<void> _captureAfter(String draftId) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      _afterImages[draftId] = File(picked.path);
    });
  }

  Future<void> _saveDraft(OvertimeDraft draft) async {
    // 🔑 FALLBACK KE DATA DRAFT
    final start = _startTimes[draft.id] ?? draft.startAsTime;
    final end = _endTimes[draft.id] ?? draft.endAsTime;

    if (start == null || end == null) {
      AppSnackBar.show(
        context,
        message: 'Lengkapi waktu mulai dan selesai terlebih dahulu',
        backgroundColor: Colors.yellow[700],
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1️⃣ SIMPAN WAKTU (HANYA JIKA BERUBAH)
      await ref
          .read(overtimeDraftListProvider.notifier)
          .updateDraftTimes(
            id: draft.id,
            startTime: TimeHelper.format(start)!,
            endTime: TimeHelper.format(end)!,
          );

      // 2️⃣ SIMPAN GAMBAR
      final beforeFile = _beforeImages[draft.id];
      final afterFile = _afterImages[draft.id];

      if (beforeFile != null || afterFile != null) {
        await ref
            .read(overtimeDraftListProvider.notifier)
            .updateDraftImages(
              id: draft.id,
              beforePath: beforeFile?.path,
              afterPath: afterFile?.path,
            );
      }

      // 3️⃣ BERSIHKAN LOCAL IMAGE STATE SAJA
      setState(() {
        _beforeImages.remove(draft.id);
        _afterImages.remove(draft.id);
      });

      if (!mounted) return;

      AppSnackBar.show(
        context,
        message: 'Draft berhasil disimpan',
        backgroundColor: Colors.green[600],
      );
    } catch (e) {
      if (!mounted) return;

      AppSnackBar.show(
        context,
        message: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red[600],
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteDraft(String draftId) async {
    await ref.read(overtimeDraftListProvider.notifier).deleteDraft(draftId);
  }

  Future<void> _uploadDraft(OvertimeDraft draft) async {
    final start = draft.startAsTime;
    final end = draft.endAsTime;

    if (start == null || end == null) {
      AppSnackBar.show(
        context,
        message: 'Lengkapi waktu mulai dan selesai terlebih dahulu',
        backgroundColor: Colors.yellow[700],
      );
      return;
    }

    final beforePath = draft.beforeImagePath;

    if (beforePath.isEmpty || !File(beforePath).existsSync()) {
      AppSnackBar.show(
        context,
        message: 'Foto sebelum lembur wajib diisi',
        backgroundColor: Colors.yellow[700],
      );
      return;
    }

    final beforeFile = File(beforePath);
    final afterFile =
        (draft.afterImagePath != null && draft.afterImagePath!.isNotEmpty)
        ? File(draft.afterImagePath!)
        : null;

    setState(() => _isUploading = true);

    try {
      await ApiService().postOvertime(
        draft.categoryId,
        start,
        end,
        draft.description,
        beforeFile,
        afterFile,
      );

      await DialogHelper.showAutoDismissSuccess(
        context,
        message: 'Laporan Lembur Berhasil Diajukan',
      );

      ref.read(overtimeDraftListProvider.notifier).deleteDraft(draft.id);
    } catch (e) {
      AppSnackBar.show(
        context,
        message: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red[600],
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drafts = ref.watch(overtimeDraftListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Draft Lembur', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade300,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.green.shade50,
      body: drafts.isEmpty
          ? const Center(child: Text('Belum ada draft'))
          : drafts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: ExpansionPanelList.radio(
                  dividerColor: Colors.transparent,
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.zero,
                  children: drafts.map((draft) {
                    return ExpansionPanelRadio(
                      canTapOnHeader: true,
                      value: draft.id, // HARUS UNIQUE
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: HeroIcon(
                              HeroIcons.clock,
                              color: Colors.green.shade400,
                            ),
                          ),
                          title: Text(draft.categoryName),
                          subtitle: Text(
                            'Dibuat: ${draft.createdAt}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                      body: Card(
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mulai',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              CustomTimePicker(
                                time: _getStartTime(draft),
                                onChanged: (time) {
                                  setState(() {
                                    _startTimes[draft.id] = time;
                                  });
                                },
                              ),

                              const SizedBox(height: 10),
                              Text(
                                'Selesai',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              CustomTimePicker(
                                time: _getEndTime(draft),
                                onChanged: (time) {
                                  setState(() {
                                    _endTimes[draft.id] = time;
                                  });
                                },
                              ),

                              const SizedBox(height: 10),
                              Text(
                                'Sebelum',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              _buildBeforeImage(draft),

                              const SizedBox(height: 10),

                              Text(
                                'Sesudah',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              _buildAfterImage(draft),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomOutlinedButton(
                                      title: 'Upload',
                                      color: Colors.grey,
                                      icon: HeroIcons.arrowUpOnSquare,
                                      isLoading: _isUploading,
                                      onPressed: () {
                                        _uploadDraft(draft);
                                      },
                                    ),
                                    CustomOutlinedButton(
                                      title: 'Simpan',
                                      color: Colors.green,
                                      icon: HeroIcons.checkCircle,
                                      isLoading: _isSaving,
                                      onPressed: () => _saveDraft(draft),
                                    ),

                                    CustomOutlinedButton(
                                      title: 'Batal',
                                      color: Colors.red,
                                      icon: HeroIcons.trash,
                                      onPressed: () => _deleteDraft(draft.id),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  Widget _buildBeforeImage(OvertimeDraft draft) {
    final File? local = _beforeImages[draft.id];
    final String? saved = draft.beforeImagePath;

    // 1️⃣ PRIORITAS: IMAGE LOKAL BARU
    if (local != null) {
      return ImageThumbnail(
        file: local,
        heroTag: 'before-preview-${draft.id}',
        onRemove: () {
          setState(() => _beforeImages.remove(draft.id));
        },
      );
    }

    // 2️⃣ IMAGE DARI DB (HARUS VALID)
    if (saved != null && saved.isNotEmpty && File(saved).existsSync()) {
      return ImageThumbnail(
        file: File(saved),
        heroTag: 'before-preview-${draft.id}',
      );
    }

    // 3️⃣ DEFAULT → PICKER
    return CustomImagePicker(
      height: 100,
      iconWidth: 30,
      captureAction: () => _captureBefore(draft.id),
    );
  }

  Widget _buildAfterImage(OvertimeDraft draft) {
    final File? local = _afterImages[draft.id];
    final String? saved = draft.afterImagePath;

    if (local != null) {
      return ImageThumbnail(
        file: local,
        heroTag: 'after-preview-${draft.id}',
        onRemove: () {
          setState(() => _afterImages.remove(draft.id));
        },
      );
    }

    if (saved != null && saved.isNotEmpty && File(saved).existsSync()) {
      return ImageThumbnail(
        file: File(saved),
        heroTag: 'after-preview-${draft.id}',
      );
    }

    return CustomImagePicker(
      height: 100,
      iconWidth: 30,
      captureAction: () => _captureAfter(draft.id),
    );
  }
}
