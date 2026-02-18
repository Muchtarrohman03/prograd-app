import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laravel_flutter/models/absence.dart';
import 'package:laravel_flutter/models/job_submission.dart';
import 'package:laravel_flutter/models/overtime.dart';
import 'package:laravel_flutter/models/stat_overview.dart';
import 'package:laravel_flutter/services/auth_service.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // 10.95.198.28
      baseUrl: 'http://10.199.78.28:80/api',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  // Hit endpoint login begin
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    return response.data;
  }
  // Hit endpoint login end

  // Hit endpoint logout begin
  Future<void> logout(String token) async {
    await _dio.post(
      '/logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
  // Hit endpoint logout end

  // get User profile begin
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
  // get User profile end

  //get user statoverview begin
  Future<StatOverview> getStatOverview() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan. User belum login.');
    }

    final response = await _dio.get(
      '/stat-overview',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return StatOverview.fromJson(response.data['data']);
  }
  //get user statoverview end

  // mengambil kategori pekerjaan begin
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
  // mengambil kategori pekerjaan end

  //membuat job submission baru begin
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
  //membuat job submission baru end

  //membuat overtime baru begin
  Future<Map<String, dynamic>> postOvertime(
    int categoryId,
    TimeOfDay start,
    TimeOfDay end,
    String? description,
    File beforeImage,
    File? afterImage,
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
  //membuat overtime baru end

  //membuat absence begin
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
  //membuat absence end

  //mengambil job submission berdasarkan tanggal begin
  Future<List<JobSubmission>> getMySubmissionsByDate(String date) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/job-submission/my-submission-by-date',
        queryParameters: {
          'date': date, // format: YYYY-MM-DD
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final List data = response.data['data'];

      return data.map((json) => JobSubmission.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    }
  }
  //mengambil job submission berdasarkan tanggal end

  //Mengambil data lembur berdasarkan tanggal begin
  Future<List<Overtime>> getMyOvertimesByDate(String date) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/overtime/my-overtime-by-date',
        queryParameters: {
          'date': date, // format: YYYY-MM-DD
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final List data = response.data['data'];

      return data.map((json) => Overtime.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    }
  }
  //Mengambil data lembur berdasarkan tanggal end

  // mengambil absence berdasarkan tanggal begin
  Future<List<Absence>> getMyAbsencesByDate(String date) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/absence/my-absence-by-date',
        queryParameters: {
          'date': date, // YYYY-MM-DD
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final List data = response.data['data'];

      return data.map((json) => Absence.fromJson(json)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    }
  }
  // mengambil absence berdasarkan tanggal end

  //ambil data job submission berdasarkan divisi begin
  Future<List<JobSubmission>> getSubmissionsByDivision() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/job-submission/spv-select-submissions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // 🔥 Pastikan status sukses
      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to load data');
      }

      final data = response.data['data'];

      // 🔥 Aman jika null atau bukan List
      if (data == null || data is! List) {
        return [];
      }

      return data
          .map<JobSubmission>((json) => JobSubmission.fromJson(json))
          .toList();
    } on DioException catch (e) {
      // 🔥 Ambil pesan backend jika ada
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          e.message ??
          'Something went wrong';

      throw Exception(message);
    }
  }
  //ambil data job submission berdasarkan divisi end

  //update status job submission (untuk role supervisor) begin
  Future<void> updateJobSubmissionStatus({
    required int id,
    required String status,
  }) async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.put(
        '/job-submission/approval-spv/$id',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to update status');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    }
  }

  //update status job submission (untuk role supervisor) end

  //ambil data lembur berdasarkan divisi begin
  Future<List<Overtime>> getDivisionOvertime() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/overtime/spv-select-overtimes',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to load data');
      }

      final data = response.data['data'];

      if (data == null || data is! List) {
        return [];
      }

      return data.map<Overtime>((json) => Overtime.fromJson(json)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          e.message ??
          'Something went wrong';

      throw Exception(message);
    }
  }

  //update status lembur (untuk role supervisor) begin
  Future<void> updateOvertime({required int id, required String status}) async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.put(
        '/overtime/approval-spv/$id',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to update status');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    }
  }
  //update status lembur (untuk role supervisor) end

  //ambil data absence berdasarkan divisi begin
  Future<List<Absence>> getDivisionAbsences() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/absence/spv-select-absences',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to load data');
      }

      final data = response.data['data'];

      if (data == null || data is! List) {
        return [];
      }

      return data.map<Absence>((json) => Absence.fromJson(json)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          e.message ??
          'Something went wrong';

      throw Exception(message);
    }
  }

  //update status absence (untuk role supervisor) begin
  Future<void> updateAbsence({required int id, required String status}) async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.put(
        '/absence/approval-spv/$id',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to update status');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    }
  }

  //update status absence (untuk role supervisor) end
}
