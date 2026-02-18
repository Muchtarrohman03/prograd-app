class StatOverview {
  final StatItem jobSubmissions;
  final StatItem absences;
  final StatItem overtime;

  const StatOverview({
    required this.jobSubmissions,
    required this.absences,
    required this.overtime,
  });

  factory StatOverview.fromJson(Map<String, dynamic> json) {
    return StatOverview(
      jobSubmissions: StatItem.fromJson(json['job_submissions']),
      absences: StatItem.fromJson(json['absences']),
      overtime: StatItem.fromJson(json['overtime']),
    );
  }
}

class StatItem {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  const StatItem({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      approved: json['approved'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}
