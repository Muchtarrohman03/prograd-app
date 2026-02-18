import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/image_thumbnail.dart';
import 'package:laravel_flutter/components/reusable/rounded_history_tile.dart';
import 'package:laravel_flutter/models/absence.dart';

class AbsenceTile extends StatelessWidget {
  final Absence absence;
  final bool? validationMode;
  final VoidCallback? onValidate;
  const AbsenceTile({
    super.key,
    required this.absence,
    this.validationMode,
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
      icon: HeroIcons.calendarDateRange,
      title: 'Izin #${_formatDate(absence.createdAt)}',
      subtitle: validationMode == true
          ? "Oleh : ${absence.employee?.name ?? 'Oleh Karyawan'}"
          : null,
      details: [
        _buildRow('Mulai', _formatDate(absence.start)),
        _buildRow('Selesai', _formatDate(absence.end)),
        _buildStatusRow(),
        _buildRow('Alasan', absence.reason),
        _buildRow('Deskripsi', absence.description),
        if (absence.imageUrl != null) ...[
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _buildImageSection(),
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
            width: 120,
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          heightFactor: 1.2,
          child: Text(
            'Bukti',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        ImageThumbnail(
          imageUrl: absence.imageUrl,
          heroTag: 'absence-evidence-${absence.id}',
          height: 200,
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
    final config = _statusConfig(absence.status);

    final HeroIcons icon = config['icon'];
    final Color color = config['color'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 🔥 ubah ke center
        children: [
          const SizedBox(
            width: 120,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(' : '),
          const SizedBox(width: 4),

          // ❌ HAPUS Expanded
          _buildStatusBadge(label: absence.status, icon: icon, color: color),
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
