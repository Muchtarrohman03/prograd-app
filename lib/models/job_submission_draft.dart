class JobSubmissionDraft {
  final String id;
  final int categoryId;
  final String categoryName;
  final String? beforeImagePath;
  final String? afterImagePath;
  final DateTime createdAt;

  JobSubmissionDraft({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.beforeImagePath,
    this.afterImagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'category_id': categoryId,
    'category_name': categoryName,
    'before_image_path': beforeImagePath,
    'after_image_path': afterImagePath,
    'created_at': createdAt.toIso8601String(),
  };

  factory JobSubmissionDraft.fromMap(Map<String, dynamic> map) {
    return JobSubmissionDraft(
      id: map['id'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      beforeImagePath: map['before_image_path'],
      afterImagePath: map['after_image_path'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
  JobSubmissionDraft copyWith({
    String? beforeImagePath,
    String? afterImagePath,
  }) {
    return JobSubmissionDraft(
      id: id,
      categoryId: categoryId,
      categoryName: categoryName,
      createdAt: createdAt,
      beforeImagePath: beforeImagePath ?? this.beforeImagePath,
      afterImagePath: afterImagePath ?? this.afterImagePath,
    );
  }
}
