// ignore_for_file: constant_identifier_names

library cp_dio_client;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:logger/logger.dart';

enum DioHttpMethod { GET, POST, PUT, DELETE, UPDATE }

class DioClient {
  final String baseUrl;
  final Dio _dio;
  final logger = Logger(printer: PrettyPrinter(methodCount: 0));

  DioClient(this.baseUrl, {Function? onUnauthorized})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: 15000, // 15 seconds
            receiveTimeout: 15000, // 15 seconds
            sendTimeout: 15000, // 15 seconds
            contentType: 'application/json',
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
    //dio Logger

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
          throw Exception('Method not implemented');
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
      bool? openThread}) async {
    return _sendRequest(method, path, bodyParam, headerParam, forceRefresh, openThread);
  }
}
