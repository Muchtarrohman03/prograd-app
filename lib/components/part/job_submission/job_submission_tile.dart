import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/rounded_history_tile.dart';
import 'package:laravel_flutter/components/reusable/image_thumbnail.dart';
import 'package:laravel_flutter/models/job_submission.dart';

class JobSubmissionTile extends StatelessWidget {
  final JobSubmission item;
  final bool? validationMode;
  final VoidCallback? onValidate;

  const JobSubmissionTile({
    super.key,
    required this.item,
    this.validationMode = false,
    this.onValidate,
  });

  Map<String, dynamic> _statusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return {'icon': HeroIcons.checkCircle, 'color': Colors.green};
      case 'rejected':
        return {'icon': HeroIcons.xCircle, 'color': Colors.red};
      default:
        return {'icon': HeroIcons.clock, 'color': Colors.orange};
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedHistoryTile(
      icon: HeroIcons.clipboardDocumentCheck,
      title: item.category?.name ?? 'Pekerjaan',
      subtitle: validationMode == true
          ? "Oleh : ${item.employee?.name ?? 'Oleh Karyawan'}"
          : null,
      details: [
        _buildStatusRow(),
        _buildRow(
          'Tanggal',
          item.submittedAt.toLocal().toString().split(' ').first,
        ),
        _buildRow('Id', item.id.toString()),

        if (item.beforeUrl != null || item.afterUrl != null) ...[
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _buildImagesSection(),
        ],
        if (validationMode == true) ...[
          const SizedBox(height: 12),
          _buildValidateButton(),
        ],
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(' : '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
    return Row(
      children: [
        if (item.beforeUrl != null)
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  heightFactor: 1.2,
                  child: Text(
                    'Sebelum',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                ImageThumbnail(
                  imageUrl: item.beforeUrl,
                  heroTag: 'job-before-${item.id}',
                  height: 140,
                ),
              ],
            ),
          ),
        if (item.afterUrl != null) const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                heightFactor: 1.2,
                child: Text(
                  'Sesudah',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              ImageThumbnail(
                imageUrl: item.afterUrl,
                heroTag: 'job-after-${item.id}',
                height: 140,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValidateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onValidate,
        child: const Text('Validasi', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStatusRow() {
    final config = _statusConfig(item.status);

    final HeroIcons icon = config['icon'];
    final Color color = config['color'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 🔥 ubah ke center
        children: [
          const SizedBox(
            width: 70,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(' : '),
          const SizedBox(width: 4),

          // ❌ HAPUS Expanded
          _buildStatusBadge(label: item.status, icon: icon, color: color),
        ],
      ),
    );
  }

  Widget _buildStatusBadge({
    required String label,
    required HeroIcons icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
