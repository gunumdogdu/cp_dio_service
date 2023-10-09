// ignore_for_file: constant_identifier_names

library cp_dio_client;

import 'dart:io';

import 'package:cp_dio_client/service/mock_api_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:logger/logger.dart';

// Enum to define HTTP methods
enum DioHttpMethod { GET, POST, PUT, DELETE, PATCH }

// DioClient class for handling API requests
class DioClient {
  static DioClient? _instance; // Singleton instance of DioClient
  final String baseUrl; // Base URL of the API
  final Map<String, dynamic>? headerParam; // Token for authorization
  final MockApiService mockApiService = MockApiService(); // MockApiService for testing
  final Dio _dio; // Dio instance for making HTTP requests
  final logger = Logger(printer: PrettyPrinter(methodCount: 0)); // Logger for logging requests and responses

  // Singleton instance method for DioClient
  static DioClient instance({
    required String baseUrl,
    Function? onUnauthorized,
    Map<String, dynamic>? headerParam,
  }) {
    _instance ??= DioClient._internal(
      baseUrl: baseUrl,
      onUnauthorized: onUnauthorized,
      headerParam: headerParam,
    );
    return _instance!;
  }

  // Private constructor for DioClient
  DioClient._internal({required this.baseUrl, Function? onUnauthorized, this.headerParam})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: headerParam,
            connectTimeout: 30000,
            receiveTimeout: 30000,
          ),
        ) {
    addInterceptors(onUnauthorized: onUnauthorized);
  }

  // Method to add interceptors for logging requests and responses
  void addInterceptors({Function? onUnauthorized}) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request details
          logger.d(
            'REQUEST[${options.method}] \n\nPATH: ${options.path}  \n\nHEADER: ${options.headers}  \n\nBODY: ${options.data}',
            time: DateTime.now(),
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response details
          logger.d(
            'RESPONSE[${response.statusCode}]  \n\nPATH: ${response.requestOptions.path}  \n\nBODY: ${response.data}',
            time: DateTime.now(),
          );
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          // Log error details
          logger.f(
            'ERROR[${e.response?.statusCode}]  \n\nPATH: ${e.requestOptions.path}  \n\nBODY: ${e.response?.data}',
            error: 'Error Path: ${e.requestOptions.path} => Error Message: ${e.message}',
            time: DateTime.now(),
          );

          // If unauthorized, call onUnauthorized function
          if (e.response?.statusCode == HttpStatus.unauthorized) onUnauthorized?.call();

          return handler.next(e);
        },
      ),
    );

    // Add DioCacheManager interceptor for caching requests
    _dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: baseUrl),
      ).interceptor,
    );
  }

  // Helper method to create Dio Options with headers
  Options _options(Map<String, dynamic>? customHeaderParams) {
    Map<String, dynamic> headers = {};
    headers.addAll(customHeaderParams ?? {});
    headers.addAll(headerParam ?? {});
    return Options(headers: headers);
  }

  // Method to send HTTP requests based on the specified method
  Future<Response?> _sendRequest(
    DioHttpMethod method,
    String pathBody,
    Map<String, dynamic> bodyParam,
    Map<String, String>? customHeaderParams,
    Map<String, dynamic>? queryParams,
    bool? forceRefresh,
  ) async {
    var uri = Uri.https(baseUrl, (pathBody.isNotEmpty ? '/$pathBody' : ''), queryParams);
    try {
      Response response;
      switch (method) {
        case DioHttpMethod.GET:
          // Send GET request with caching options
          response = await _dio.getUri(
            uri,
            options: buildCacheOptions(
              const Duration(days: 7),
              forceRefresh: forceRefresh ?? true,
              options: _options(customHeaderParams),
            ),
          );
          break;
        case DioHttpMethod.POST:
          // Send POST request
          response = await _dio.postUri(uri, data: bodyParam, options: _options(customHeaderParams));
          break;
        case DioHttpMethod.DELETE:
          // Send DELETE request
          response = await _dio.deleteUri(uri, data: bodyParam, options: _options(customHeaderParams));
          break;
        case DioHttpMethod.PUT:
          // Send PUT request
          response = await _dio.putUri(uri, data: bodyParam, options: _options(customHeaderParams));
          break;
           case DioHttpMethod.PATCH:
          // Send PUT request
          response = await _dio.patchUri(uri, data: bodyParam, options: _options(customHeaderParams));
          break;
        default:
          // Handle unsupported HTTP methods
          throw DioError(requestOptions: RequestOptions(path: pathBody), error: 'Method not found');
      }
      return response;
    } catch (e) {
      // Log and throw DioError for failed requests
      logger.e('ERROR => PATH: $pathBody => BODY: $bodyParam', error: e);
      throw DioError(requestOptions: RequestOptions(path: pathBody), error: e.toString());
    }
  }

  /// Public method to make HTTP requests
  /// [method] is the HTTP method to be used e.g. DioHttpMethod.GET
  ///
  /// [path] is the path of the API endpoint e.g. 'posts'
  ///
  /// [bodyParam] is the body of the request e.g. {"title": 'I am in love with someone.', "userId": "5"}
  ///
  /// [forceRefresh] is a boolean to force refresh the cache
  ///
  ///Example:
  ///```dart
  ///final response = await dioClient.request(
  ///  DioHttpMethod.GET,
  /// 'posts',
  /// bodyParam: {"title": 'I am in love with someone.', "userId": "5"},
  /// forceRefresh: true,
  /// );
  /// ```
  /// Returns a Future<Response?> object
  /// ```dart
  Future<Response?> request(DioHttpMethod method, String path,
      {Map<String, dynamic> bodyParam = const {},
      Map<String, String>? headerParam,
      bool? forceRefresh,
      Map<String, dynamic>? queryParams}) async {
    return await _sendRequest(
      method,
      path,
      bodyParam,
      headerParam,
      queryParams,
      forceRefresh,
    );
  }
}
