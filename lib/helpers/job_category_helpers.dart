import 'package:flutter/material.dart';
import 'package:laravel_flutter/models/job_category.dart';
import 'package:laravel_flutter/services/api_service.dart';

class JobCategoryHelper {
  final ApiService _apiService = ApiService();

  Future<List<JobCategory>> fetchJobCategories() async {
    try {
      final response = await _apiService.getJobCategories();

      // 👇 LOG response
      debugPrint('Job categories response: $response');

      final List data = response['data'];

      return data.map((json) => JobCategory.fromJson(json)).toList();
    } catch (e, s) {
      debugPrint('ERROR FETCH JOB CATEGORY: $e');
      debugPrint('STACKTRACE: $s');
      rethrow; // ⬅️ JANGAN ditelan
    }
  }
}
