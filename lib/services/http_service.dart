import 'package:dio/dio.dart';

class HttpService {
  final Dio _dio = Dio();

  Future<dynamic> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<dynamic> post(String url, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<dynamic> patch(String url, dynamic data) async {
    try {
      final response = await _dio.patch(url, data: data);
      return response.data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<dynamic> put(String url, dynamic data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response.data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return response.data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
