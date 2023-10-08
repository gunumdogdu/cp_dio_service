import 'package:dio/dio.dart';

import 'api_service.dart';

class MockApiService extends ApiService {
  @override
  Future<Response> get(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration}) {
    Future.delayed(Duration(seconds: duration ?? 2));
    final response = Response(
      requestOptions: RequestOptions(path: url),
      data: mockData,
      statusMessage: 'OK',
      statusCode: 200,
    );
    return Future.value(response);
  }

  @override
  Future<Response> delete(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration}) {
    Future.delayed(Duration(seconds: duration ?? 2));
    final response = Response(
      requestOptions: RequestOptions(path: url),
      data: mockData,
      statusMessage: 'OK',
      statusCode: 200,
    );
    return Future.value(response);
  }

  @override
  Future<Response> post(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration}) {
    Future.delayed(Duration(seconds: duration ?? 2));
    final response = Response(
      requestOptions: RequestOptions(path: url),
      data: mockData,
      statusMessage: 'Created',
      statusCode: 201,
    );
    return Future.value(response);
  }

  @override
  Future<Response> put(String url, {Map<String, dynamic>? params, Map<String, dynamic>? mockData, int? duration}) {
    Future.delayed(Duration(seconds: duration ?? 2));
    final response = Response(
      requestOptions: RequestOptions(path: url),
      data: mockData,
      statusMessage: 'Updated',
      statusCode: 200,
    );
    return Future.value(response);
  }
}
