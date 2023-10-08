import 'package:dio/dio.dart';

abstract class ApiService {
  /// This method is used to make a GET request for the test environment
  /// ```dart
  /// final response = await dioClient.mockApiService.get( 'posts', mockData: {"title": 'I am in love with someone.', "userId": "5"}, duration: 2);
  /// ```
  Future<Response> get(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration});

  /// This method is used to make a POST request for the test environment
  Future<Response> post(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration});

  /// This method is used to make a PUT request for the test environment
  Future<Response> put(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration});

  /// This method is used to make a DELETE request for the test environment
  Future<Response> delete(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration});
}
