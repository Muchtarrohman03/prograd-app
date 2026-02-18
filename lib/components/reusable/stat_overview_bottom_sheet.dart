import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/models/stat_overview.dart';

class StatOverviewBottomSheet extends StatelessWidget {
  final String title;
  final StatItem stat;
  final HeroIcon icon;

  const StatOverviewBottomSheet({
    super.key,
    required this.title,
    required this.stat,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(icon.icon, color: Colors.grey, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              // PIE CHART
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 55,
                        sections: _buildSections(),
                      ),
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOutCubic,
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          stat.total.toString(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // LEGEND
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: Colors.green,
                    label: 'Disetujui',
                    value: stat.approved,
                  ),
                  const SizedBox(height: 12),
                  _LegendItem(
                    color: Colors.yellow.shade700,
                    label: 'Menunggu',
                    value: stat.pending,
                  ),
                  const SizedBox(height: 12),
                  _LegendItem(
                    color: Colors.red,
                    label: 'Ditolak',
                    value: stat.rejected,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    if (stat.total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey.shade300,
          radius: 20,
          title: '',
        ),
      ];
    }

    return [
      PieChartSectionData(
        value: stat.approved.toDouble(),
        color: Colors.green,
        radius: 20,
        title: '',
      ),
      PieChartSectionData(
        value: stat.pending.toDouble(),
        color: Colors.yellow.shade700,
        radius: 20,
        title: '',
      ),
      PieChartSectionData(
        value: stat.rejected.toDouble(),
        color: Colors.red,
        radius: 20,
        title: '',
      ),
    ];
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($value)',
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
