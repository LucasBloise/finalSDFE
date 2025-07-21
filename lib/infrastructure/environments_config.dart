import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvironmentConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static String get baseUrl {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw Exception('BASE_URL environment variable is not configurated');
    }
    return baseUrl;
  }

  static String get auth0Domain {
    final auth0Domain = dotenv.env['AUTH0_DOMAIN'];
    if (auth0Domain == null) {
      throw Exception('AUTH0_DOMAIN environment variable is not configurated');
    }
    return auth0Domain;
  }

  static String get auth0ClientId {
    final auth0ClientId = dotenv.env['AUTH0_CLIENT_ID'];
    if (auth0ClientId == null) {
      throw Exception(
        'AUTH0_CLIENT_ID environment variable is not configurated',
      );
    }
    return auth0ClientId;
  }
}
