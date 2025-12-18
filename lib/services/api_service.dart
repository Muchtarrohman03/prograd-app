import 'package:dio/dio.dart';
import 'package:laravel_flutter/services/auth_service.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.40.30.28:80/api",
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
}
