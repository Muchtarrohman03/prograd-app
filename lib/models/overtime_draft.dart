import 'package:flutter/material.dart';
import 'package:laravel_flutter/helpers/time_helper.dart';

class OvertimeDraft {
  final String id;
  final int categoryId;
  final String categoryName;

  final String startTime; // ⬅️ NOT NULL
  final String endTime; // ⬅️ NOT NULL

  final String? description;
  final String beforeImagePath;
  final String? afterImagePath;
  final DateTime createdAt;

  const OvertimeDraft({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.startTime,
    required this.endTime,
    this.description,
    required this.beforeImagePath,
    this.afterImagePath,
    required this.createdAt,
  });

  /// UI helper
  TimeOfDay? get startAsTime => TimeHelper.parseNullable(startTime);
  TimeOfDay? get endAsTime => TimeHelper.parseNullable(endTime);

  Map<String, dynamic> toMap() => {
    'id': id,
    'category_id': categoryId,
    'category_name': categoryName,
    'start_time': startTime,
    'end_time': endTime,
    'description': description,
    'before_image_path': beforeImagePath,
    'after_image_path': afterImagePath,
    'created_at': createdAt.toIso8601String(),
  };

  factory OvertimeDraft.fromMap(Map<String, dynamic> map) {
    return OvertimeDraft(
      id: map['id'] as String,
      categoryId: map['category_id'] as int,
      categoryName: map['category_name'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      description: map['description'] as String?,
      beforeImagePath: map['before_image_path'] as String,
      afterImagePath: map['after_image_path'] as String?,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  OvertimeDraft copyWith({
    String? categoryName,
    String? startTime,
    String? endTime,
    String? description,
    String? beforeImagePath,
    String? afterImagePath,
  }) {
    return OvertimeDraft(
      id: id,
      categoryId: categoryId,
      categoryName: categoryName ?? this.categoryName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      beforeImagePath: beforeImagePath ?? this.beforeImagePath,
      afterImagePath: afterImagePath ?? this.afterImagePath,
      createdAt: createdAt,
    );
  }
}
