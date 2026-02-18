import 'package:laravel_flutter/models/employee.dart';

class Absence {
  final int id;
  final int employeeId;
  final Employee? employee;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String reason;
  final String status;
  final String description;
  final String? evidence;
  final String? imageUrl;

  Absence({
    required this.id,
    required this.employeeId,
    this.employee,
    required this.start,
    required this.end,
    required this.reason,
    required this.status,
    required this.description,
    this.evidence,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      employeeId: json['employee_id'],
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      reason: json['reason'],
      status: json['status'],
      description: json['description'],
      evidence: json['evidence'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
