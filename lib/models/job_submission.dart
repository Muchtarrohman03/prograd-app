import 'package:laravel_flutter/models/employee.dart';
import 'package:laravel_flutter/models/job_category.dart';

class JobSubmission {
  final int id;
  final int categoryId;
  final int employeeId;
  final String status;
  final DateTime submittedAt;
  final String? imageUrl;
  final Employee? employee;
  final JobCategory? category;

  JobSubmission({
    required this.id,
    required this.categoryId,
    required this.employeeId,
    required this.status,
    required this.submittedAt,
    this.imageUrl,
    this.employee,
    this.category,
  });

  factory JobSubmission.fromJson(Map<String, dynamic> json) {
    return JobSubmission(
      id: json['id'],
      categoryId: json['category_id'],
      employeeId: json['employee_id'],
      status: json['status'],
      submittedAt: DateTime.parse(json['submitted_at']),
      imageUrl: json['image_url'],
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
      category: json['category'] != null
          ? JobCategory.fromJson(json['category'])
          : null,
    );
  }
}
