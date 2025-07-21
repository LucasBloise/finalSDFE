import 'dart:convert';
import 'package:final_sd_front/integrations/http_helper/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PrettyDioLogger extends Interceptor {
  final bool request;
  final bool requestHeader;
  final bool requestBody;
  final bool responseHeader;
  final bool responseBody;
  final bool error;
  final bool compact;
  final int maxWidth;

  static const String _defaultLogPrefixSuccess = '🟢 HTTP';
  static const String _defaultLogPrefixError = '🔴 HTTP';
  static const String _defaultLogPrefixInfo = '🔵 HTTP';

  PrettyDioLogger({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.compact = false,
    this.maxWidth = 90,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode || !HttpHelper.loggingEnabled) {
      handler.next(options);
      return;
    }

    if (request) {
      _printRequestInfo(options);
    }
    if (requestHeader) {
      _printMapAsTable(options.headers, header: 'Headers');
      _printLine('╠');
    }
    if (requestBody) {
      _printRequestBody(options);
    }
    _printLine('╚');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode || !HttpHelper.loggingEnabled) {
      handler.next(response);
      return;
    }

    _printResponseInfo(response);
    if (responseHeader) {
      _printLine('╠');
      _printMapAsTable(response.headers.map, header: 'Headers');
    }

    if (responseBody) {
      _printLine('╠');
      _printResponseBody(response);
    }
    _printLine('╚');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode || !HttpHelper.loggingEnabled) {
      handler.next(err);
      return;
    }

    if (error) {
      _printErrorInfo(err);
      if (err.response != null) {
        _printResponseInfo(err.response!);
        if (responseHeader) {
          _printLine('╠');
          _printMapAsTable(err.response!.headers.map, header: 'Headers');
        }
        if (responseBody) {
          _printLine('╠');
          _printResponseBody(err.response!);
        }
      }
      _printLine('╚');
    }
    handler.next(err);
  }

  void _printRequestInfo(RequestOptions options) {
    _printLine('╔');
    _printLine('╠ $_defaultLogPrefixInfo REQUEST ');
    _printLine('╠ URL: ${options.uri}');
    _printLine('╠ METHOD: ${options.method}');
    _printLine('╠');
  }

  void _printResponseInfo(Response response) {
    final statusCode = response.statusCode;
    final isSuccess =
        statusCode != null && statusCode >= 200 && statusCode < 300;
    final prefix =
        isSuccess ? _defaultLogPrefixSuccess : _defaultLogPrefixError;

    _printLine('╔');
    _printLine(
      '╠ $prefix RESPONSE [${response.statusCode}] ⏱ ${response.requestOptions.extra['timeElapsed'] ?? 'Unknown'}ms',
    );
    _printLine('╠ URL: ${response.requestOptions.uri}');
    _printLine('╠');
  }

  void _printErrorInfo(DioException err) {
    _printLine('╔');
    _printLine('╠ $_defaultLogPrefixError ERROR');
    _printLine('╠ URL: ${err.requestOptions.uri}');
    _printLine('╠ ${err.error}');
    _printLine('╠');
  }

  void _printRequestBody(RequestOptions options) {
    if (options.data == null) {
      _printLine('╠ Body: Empty');
      return;
    }

    if (options.data is FormData) {
      final formData = options.data as FormData;
      _printLine('╠ Form data:');

      for (final field in formData.fields) {
        _printLine('╠   ${field.key}: ${field.value}');
      }

      for (final file in formData.files) {
        _printLine(
          '╠   ${file.key}: (file) ${file.value.filename}, type: ${file.value.contentType}',
        );
      }
      return;
    }

    try {
      String body;
      if (options.data is Map || options.data is List) {
        body = json.encode(options.data);
        _printLine('╠ Body:');
        _printPrettyJson(body);
      } else {
        _printLine('╠ Body: ${options.data}');
      }
    } catch (e) {
      _printLine('╠ Body: ${options.data}');
    }
  }

  void _printResponseBody(Response response) {
    if (response.data == null) {
      _printLine('╠ Body: Empty');
      return;
    }

    try {
      String body;
      if (response.data is Map || response.data is List) {
        body = json.encode(response.data);
        _printLine('╠ Body:');
        _printPrettyJson(body);
      } else {
        _printLine('╠ Body: ${response.data}');
      }
    } catch (e) {
      _printLine('╠ Body: ${response.data}');
    }
  }

  void _printLine(String text) {
    if (kDebugMode && HttpHelper.loggingEnabled) {
      // ignore: avoid_print
      print(text);
    }
  }

  void _printPrettyJson(String input) {
    try {
      var object = json.decode(input);
      var prettyString = const JsonEncoder.withIndent('  ').convert(object);

      // Divide el JSON en líneas para imprimirlo más bonito
      final lines = prettyString.split('\n');
      for (var line in lines) {
        _printLine('╠   $line');
      }
    } catch (e) {
      _printLine('╠   $input');
    }
  }

  void _printMapAsTable(Map<String, dynamic> map, {String? header}) {
    if (map.isEmpty) {
      _printLine('╠ $header: Empty');
      return;
    }

    _printLine('╠ $header:');
    map.forEach((key, value) {
      if (value is List) {
        _printLine('╠   $key: [List of ${value.length} items]');
      } else {
        _printLine('╠   $key: $value');
      }
    });
  }
}
