import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvironmentConfig {
  static Future<void> init() async {
    await dotenv.load();
  }

  static String get baseUrl {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw Exception('BASE_URL environment variable is not configurated');
    }
    return baseUrl;
  }
}
