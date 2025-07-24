import 'dart:io';

import 'package:final_sd_front/integrations/http_helper/i_http_helper.dart';
import 'package:final_sd_front/integrations/http_helper/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

class HttpHelper implements IHttpHelper {
  final Dio _privateDio;
  final Dio _publicRequestsDio;

  static bool loggingEnabled = false;

  static void toggleLogging(bool enable) {
    loggingEnabled = enable;
  }

  HttpHelper({required Dio drCallDio, required Dio publicRequestsDio})
      : _privateDio = drCallDio,
        _publicRequestsDio = publicRequestsDio {
    if (kDebugMode && loggingEnabled) {
      _privateDio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
          maxWidth: 90,
        ),
      );

      _publicRequestsDio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
          maxWidth: 90,
        ),
      );

      _addTimingInterceptor(_privateDio);
      _addTimingInterceptor(_publicRequestsDio);
    }
  }

  void _addTimingInterceptor(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['startTime'] = DateTime.now().millisecondsSinceEpoch;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final startTime = response.requestOptions.extra['startTime'];
          response.requestOptions.extra['timeElapsed'] =
              DateTime.now().millisecondsSinceEpoch - startTime;
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response != null &&
              e.requestOptions.extra.containsKey('startTime')) {
            final startTime = e.requestOptions.extra['startTime'];
            e.requestOptions.extra['timeElapsed'] =
                DateTime.now().millisecondsSinceEpoch - startTime;
          }
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    bool publicRequest = false,
  }) async {
    final dio = publicRequest ? _publicRequestsDio : _privateDio;
    final Response<T> response = await dio.get(url, queryParameters: query);
    final httpResponse = HttpResponse<T>(response.data, response.statusCode);

    return httpResponse;
  }

  @override
  Future<HttpResponse<T>> patch<T>(
    String url, {
    dynamic data,
    bool publicRequest = false,
  }) async {
    final dio = publicRequest ? _publicRequestsDio : _privateDio;
    final Response<T> response = await dio.patch(url, data: data);
    final httpResponse = HttpResponse<T>(response.data, response.statusCode);

    return httpResponse;
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String url, {
    dynamic data,
    bool publicRequest = false,
    Map<String, String>? headers,
  }) async {
    final dio = publicRequest ? _publicRequestsDio : _privateDio;

    final combinedHeaders = Map<String, String>.from(dio.options.headers);
    if (headers != null) {
      combinedHeaders.addAll(headers);
    }

    final Response<T> response = await dio.post(
      url,
      data: data,
      options: Options(headers: combinedHeaders),
    );

    final httpResponse = HttpResponse<T>(response.data, response.statusCode);
    return httpResponse;
  }

  @override
  Future<HttpResponse<T>> put<T>(
    String url, {
    dynamic data,
    bool publicRequest = false,
  }) async {
    final dio = publicRequest ? _publicRequestsDio : _privateDio;
    final Response<T> response = await dio.put(url, data: data);
    final httpResponse = HttpResponse<T>(response.data, response.statusCode);

    return httpResponse;
  }

  @override
  Future<HttpResponse<T>> delete<T>(
    String url, {
    dynamic data,
    bool publicRequest = false,
  }) async {
    final dio = publicRequest ? _publicRequestsDio : _privateDio;
    final Response<T> response = await dio.delete(url, data: data);
    final httpResponse = HttpResponse<T>(response.data, response.statusCode);

    return httpResponse;
  }

  @override
  Future<void> addHeader(String key, dynamic value) async {
    print('adding header $key: $value');
    _privateDio.options.headers[key] = value;
  }

  @override
  Future<HttpResponse<T>> postFile<T>(
    String path, {
    required File file,
    Map<String, dynamic>? additionalData,
  }) async {
    final dio = _privateDio;
    final formMap = <String, dynamic>{};

    String? mimeType = lookupMimeType(file.path);
    final splited = file.path.split('.');
    if (splited[splited.length - 1] == 'm4a') {
      mimeType = 'audio/m4a';
    }
    final parts = mimeType!.split('/');
    final contentType =
        (parts.length == 2) ? DioMediaType(parts[0], parts[1]) : null;

    formMap["file"] = await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
      contentType: contentType,
    );

    if (additionalData != null) {
      formMap.addAll(additionalData);
    }

    FormData formData = FormData.fromMap(formMap);
    final Response<T> response = await dio.post(path, data: formData);

    return HttpResponse<T>(response.data, response.statusCode);
  }
}
