import 'package:dio/dio.dart';

class HttpClientInstances {
  static Dio httpClient = Dio(
    BaseOptions(
      validateStatus: (int? statusCode) {
        if (statusCode != null && statusCode == 403) {
          return false;
        }
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
}
