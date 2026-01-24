import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laravel_flutter/models/job_submission.dart';
import 'package:laravel_flutter/services/auth_service.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // 10.95.198.28
      baseUrl: "http://10.95.198.28:80/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  // Hit endpoint login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    return response.data;
  }

  // Hit endpoint logout
  Future<void> logout(String token) async {
    await _dio.post(
      '/logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // ambil profil pengguna saat ini
  Future<Map<String, dynamic>> getMyProfile() async {
    final token = await AuthService().getToken(); // ambil token dari storage

    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    final response = await _dio.get(
      '/my-profile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  // ambil ringkasan pengajuan pekerjaan
  Future<Map<String, dynamic>> getJobSubmissionSummary() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    try {
      final response = await _dio.get(
        '/job-submissions/summary',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan');
      } else {
        throw Exception('Gagal terhubung ke server');
      }
    }
  }

  //ambil data job category
  Future<Map<String, dynamic>> getJobCategories() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan. User belum login.');
    }

    final response = await _dio.get(
      '/job-categories',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    return response.data;
  }

  //membuat job submission baru
  Future<Map<String, dynamic>> postJobSubmission(
    int categoryId,
    File beforeImage,
    File? afterImage,
  ) async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    try {
      final formData = FormData.fromMap({
        'category_id': categoryId,
        'before': await MultipartFile.fromFile(
          beforeImage.path,
          filename: beforeImage.path.split('/').last,
        ),
        if (afterImage != null)
          'after': await MultipartFile.fromFile(
            afterImage.path,
            filename: afterImage.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        '/job-submission/store',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan');
      } else {
        throw Exception('Gagal terhubung ke server');
      }
    }
  }

  //membuat overtime baru
  Future<Map<String, dynamic>> postOvertime(
    int categoryId,
    TimeOfDay start,
    TimeOfDay end,
    String? description,
    File imageFile,
  ) async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    try {
      final formData = FormData.fromMap({
        'category_id': categoryId,
        'description': description,
        'start': formatTime(start),
        'end': formatTime(end),
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/overtime/store',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan');
      } else {
        throw Exception('Gagal terhubung ke server');
      }
    }
  }

  //mengambil data job submission pengguna berdasarkan tanggal dibuat
  Future<List<JobSubmission>> getMySubmissionsByDate(String date) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }
    try {
      final response = await _dio.get(
        '/job-submissions/my-submissions-by-date',
        queryParameters: {
          'date': date, // YYYY-MM-DD
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List data = response.data['data'];

      return data.map((json) => JobSubmission.fromJson(json)).toList();
    } on DioException catch (e) {
      // Error dari server
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      // Error lainnya
      rethrow;
    }
  }

  //membuat absence
  Future<Map<String, dynamic>> postAbsence(
    DateTime start,
    DateTime end,
    String reason,
    File evidence,
    String description,
  ) async {
    //ambil token dari auth_service.dart
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Token not found. User not authenticated');
    }
    String formatDate(DateTime date) {
      final year = date.year.toString().padRight(4, '0');
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    }

    try {
      final formData = FormData.fromMap({
        'start': formatDate(start),
        'end': formatDate(end),
        'reason': reason,
        'evidence': await MultipartFile.fromFile(
          evidence.path,
          filename: evidence.path.split('/').last,
        ),
        'description': description,
      });

      final response = await _dio.post(
        '/absence/store',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan');
      } else {
        throw Exception('Gagal terhubung ke server');
      }
    }
  }
}
