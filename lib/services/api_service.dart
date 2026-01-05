import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laravel_flutter/services/auth_service.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      //10.170.77.28
      //192.168.1.66
      baseUrl: "http://10.170.77.28:80/api",
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
    File imageFile,
  ) async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. User belum login.");
    }

    try {
      final formData = FormData.fromMap({
        'category_id': categoryId,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/job-submissions',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // Content-Type otomatis di-set Dio
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
        '/overtimes',
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
