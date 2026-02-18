import 'package:flutter/material.dart';
import 'package:laravel_flutter/models/employee.dart';
import 'package:laravel_flutter/models/job_category.dart';

class Overtime {
  final int id;
  final int categoryId;
  final int employeeId;

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final String status;
  final String? description;
  final DateTime submittedAt;

  final String? before;
  final String? after;
  final String? beforeUrl;
  final String? afterUrl;

  final Employee? employee;
  final JobCategory? category;

  Overtime({
    required this.id,
    required this.categoryId,
    required this.employeeId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.description,
    required this.submittedAt,
    this.before,
    this.after,
    this.beforeUrl,
    this.afterUrl,
    this.employee,
    this.category,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) {
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return Overtime(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      employeeId: json['employee_id'] as int,
      startTime: parseTime(json['start']), // ⬅️ FIX
      endTime: parseTime(json['end']), // ⬅️ FIX
      status: json['status'].toString(), // ⬅️ FIX
      description: json['description'],
      submittedAt: DateTime.parse(json['submitted_at']),
      before: json['before'],
      after: json['after'],
      beforeUrl: json['before_url'],
      afterUrl: json['after_url'],
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
      category: json['category'] != null
          ? JobCategory.fromJson(json['category'])
          : null,
    );
  }
}
