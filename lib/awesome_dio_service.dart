// ignore_for_file: constant_identifier_names

library cp_dio_client;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:logger/logger.dart';

enum DioHttpMethod { GET, POST, PUT, DELETE, UPDATE }

class DioClient {
  static DioClient? _instance;
  final String baseUrl;
  final Dio _dio;
  final logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static DioClient instance(
    String baseUrl, {
    Function? onUnauthorized,
  }) {
    _instance ??= DioClient._internal(baseUrl, onUnauthorized: onUnauthorized);
    return _instance!;
  }

  DioClient._internal(
    this.baseUrl, {
    Function? onUnauthorized,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: 30000,
            receiveTimeout: 30000,
          ),
        ) {
    addInterceptors(onUnauthorized: onUnauthorized);
  }

  /// Interceptors
  void addInterceptors({Function? onUnauthorized}) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d(
            'REQUEST[${options.method}] \n\nPATH: ${options.path}  \n\nHEADER: ${options.headers}  \n\nBODY: ${options.data}',
            time: DateTime.now(),
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d(
            'RESPONSE[${response.statusCode}]  \n\nPATH: ${response.requestOptions.path}  \n\nBODY: ${response.data}',
            time: DateTime.now(),
          );
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          logger.f(
            'ERROR[${e.response?.statusCode}]  \n\nPATH: ${e.requestOptions.path}  \n\nBODY: ${e.response?.data}',
            error: 'Error Path: ${e.requestOptions.path} => Error Message: ${e.message}',
            time: DateTime.now(),
            // stackTrace: e.stackTrace,
          );

          /// If unauthorized call onUnauthorized function
          if (e.response?.statusCode == HttpStatus.unauthorized) onUnauthorized?.call();

          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: baseUrl),
      ).interceptor,
    );
  }

  Options _options(Map<String, dynamic>? headerParam) => Options(headers: headerParam ?? {});

  Future<Response?> _sendRequest(
    DioHttpMethod method,
    String pathBody,
    Map<String, dynamic> bodyParam,
    Map<String, String>? headerParam,
    bool? forceRefresh,
    bool? openThread,
  ) async {
    var uri = Uri.https(baseUrl, (pathBody.isNotEmpty ? '/$pathBody' : ''));
    try {
      Response response;
      switch (method) {
        case DioHttpMethod.GET:
          response = await _dio.getUri(
            uri,
            options: buildCacheOptions(
              const Duration(days: 7),
              forceRefresh: forceRefresh ?? true,
              options: _options(headerParam),
            ),
          );

          break;
        case DioHttpMethod.POST:
          response = await _dio.postUri(uri, data: bodyParam, options: _options(headerParam));
          break;
        case DioHttpMethod.DELETE:
          response = await _dio.deleteUri(uri, data: bodyParam, options: _options(headerParam));
          break;
        case DioHttpMethod.PUT:
          response = await _dio.putUri(uri, data: bodyParam, options: _options(headerParam));
          break;

        default:
          throw DioError(requestOptions: RequestOptions(path: pathBody), error: 'Method not found');
      }
      return response;
    } catch (e) {
      logger.e('ERROR => PATH: $pathBody => BODY: $bodyParam', error: e);
      throw DioError(requestOptions: RequestOptions(path: pathBody), error: e.toString());
    }
  }

  Future<Response?> request(DioHttpMethod method, String path,
      {Map<String, dynamic> bodyParam = const {},
      Map<String, String>? headerParam,
      bool? forceRefresh,
      bool? openThread,
      Function? onUnauthorized}) async {
    return await _sendRequest(method, path, bodyParam, headerParam, forceRefresh, openThread);
  }
}
