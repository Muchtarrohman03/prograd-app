class JobSubmissionSummary {
  final int today;
  final int yesterday;
  final String trend;
  final String description;

  JobSubmissionSummary({
    required this.today,
    required this.yesterday,
    required this.trend,
    required this.description,
  });

  factory JobSubmissionSummary.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return JobSubmissionSummary(
      today: data['today'],
      yesterday: data['yesterday'],
      trend: data['trend'],
      description: data['description'],
    );
  }
}
