import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_flutter/components/reusable/custom_image_picker.dart';
import 'package:laravel_flutter/components/reusable/image_thumbnail.dart';
import 'package:laravel_flutter/helpers/dialog_helper.dart';
import 'package:laravel_flutter/models/job_submission_draft.dart';
import 'package:laravel_flutter/providers/job_submission_draft_provider.dart';
import 'package:laravel_flutter/services/api_service.dart';

class JobSubmissionDraftPage extends ConsumerStatefulWidget {
  const JobSubmissionDraftPage({super.key});

  @override
  ConsumerState<JobSubmissionDraftPage> createState() =>
      _JobSubmissionDraftPageState();
}

class _JobSubmissionDraftPageState
    extends ConsumerState<JobSubmissionDraftPage> {
  final Map<String, File?> _beforeImages = {};
  final Map<String, File?> _afterImages = {};

  bool _isSaving = false;
  bool _isUploading = false;

  Future<void> _captureBefore(String draftId) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _beforeImages[draftId] = File(image.path);
      });
    }
  }

  Future<void> _captureAfter(String draftId) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _afterImages[draftId] = File(image.path);
      });
    }
  }

  Future<void> _updateDraft(JobSubmissionDraft draft) async {
    final before = _beforeImages[draft.id];
    final after = _afterImages[draft.id];

    if (before == null && after == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak ada perubahan untuk disimpan'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
          backgroundColor: Colors.yellow.shade700,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(draftListProvider.notifier)
          .updateDraftImages(
            id: draft.id,
            beforePath: before?.path,
            afterPath: after?.path,
          );

      // 🔥 RESET LOCAL STATE KHUSUS DRAFT INI
      setState(() {
        _beforeImages.remove(draft.id);
        _afterImages.remove(draft.id);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Memperbarui Draft Pekerjaan'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi Kesalahan: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _postJobSubmission(JobSubmissionDraft draft) async {
    if (draft.beforeImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Foto sebelum pekerjaan wajib ditambahkan'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
          backgroundColor: Colors.yellow.shade700,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      await ApiService().postJobSubmission(
        draft.categoryId,
        File(draft.beforeImagePath!),
        draft.afterImagePath != null ? File(draft.afterImagePath!) : null,
      );

      await ref.read(draftListProvider.notifier).deleteDraft(draft.id);

      if (!mounted) return;

      await DialogHelper.showAutoDismissSuccess(
        context,
        message: 'Laporan Pekerjaan Berhasil Diajukan',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload gagal: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drafts = ref.watch(draftListProvider);
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Buat Laporan Kerja',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade300,
      ),
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
                            backgroundColor: Colors.blue.shade100,
                            child: HeroIcon(
                              HeroIcons.clipboardDocumentList,
                              color: Colors.blue.shade400,
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
                                    //upload button
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: _isUploading
                                          ? null
                                          : () => _postJobSubmission(draft),
                                      icon: _isUploading
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const HeroIcon(
                                              HeroIcons.arrowUpOnSquare,
                                              size: 12,
                                            ),
                                      label: const Text(
                                        'Upload',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    //save button
                                    const SizedBox(width: 5),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.green,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: _isSaving
                                          ? null
                                          : () => _updateDraft(draft),
                                      icon: _isSaving
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const HeroIcon(
                                              HeroIcons.checkCircle,
                                              size: 12,
                                              color: Colors.green,
                                            ),
                                      label: const Text(
                                        'Simpan',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    //delete button
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () async {
                                        ref
                                            .read(draftListProvider.notifier)
                                            .deleteDraft(draft.id);
                                      },
                                      icon: const HeroIcon(
                                        HeroIcons.trash,
                                        size: 12,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        'Batal',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
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

  Widget _buildBeforeImage(JobSubmissionDraft draft) {
    final File? local = _beforeImages[draft.id];
    final String? saved = draft.beforeImagePath;

    if (local != null) {
      return ImageThumbnail(file: local, heroTag: 'before-preview-${draft.id}');
    }

    if (saved != null) {
      return ImageThumbnail(
        file: File(saved),
        heroTag: 'before-preview-${draft.id}',
      );
    }

    return CustomImagePicker(
      height: 100,
      iconWidth: 30,
      captureAction: () => _captureBefore(draft.id),
    );
  }

  Widget _buildAfterImage(JobSubmissionDraft draft) {
    final File? local = _afterImages[draft.id];
    final String? saved = draft.afterImagePath;

    if (local != null) {
      return ImageThumbnail(file: local, heroTag: 'after-preview-${draft.id}');
    }

    if (saved != null) {
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
