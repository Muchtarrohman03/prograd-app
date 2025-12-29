import 'package:dio/dio.dart';

class WeatherService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final String apiKey = '7bcdfe6a5a7c0f5994e9f35737b33b6e';

  WeatherService() {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil cuaca');
    }
  }

  Future<Map<String, dynamic>> getWeatherByLocation(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Gagal mengambil cuaca lokasi');
    }
  }
}
