import 'package:dio/dio.dart';

class HttpClientInstances {
  static Dio httpClient = Dio(
    BaseOptions(
      validateStatus: (int? statusCode) {
        return true;
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {},
    ),
  );

  static Dio httpPublicClient = Dio(
    BaseOptions(
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  static void addBaseUrl(String baseUrl) {
    httpClient.options.baseUrl = baseUrl;
  }

  static void addHeaders(Map<String, String> headers) {
    httpClient.options.headers.addAll(headers);
  }
}
