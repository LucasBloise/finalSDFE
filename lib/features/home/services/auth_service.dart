import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:final_sd_front/infrastructure/environments_config.dart';
import 'package:final_sd_front/integrations/http_helper/i_http_helper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService implements IAuthService {
  final IHttpHelper _httpHelper;

  AuthService({required IHttpHelper httpHelper}) : _httpHelper = httpHelper;

  Credentials? _credentials;
  Auth0Web auth0 = Auth0Web(
    EnvironmentConfig.auth0Domain,
    EnvironmentConfig.auth0ClientId,
  );

  @override
  Future<void> signIn() async {
    try {
      await auth0.loginWithRedirect(
        audience: 'https://finalSistemasDistribuidos',
        redirectUrl: 'http://localhost:3000/home',
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth0.logout(returnToUrl: 'http://localhost:3000');
      _credentials = null;
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await auth0.hasValidCredentials();
  }

  @override
  Future<void> init() async {
    await auth0.onLoad(audience: 'https://finalSistemasDistribuidos').then(
      (final credentials) async {
        _credentials = credentials;
        if (_credentials?.accessToken != null) {
          await _httpHelper.addHeader(
              'Authorization', 'Bearer ${_credentials!.accessToken}');

          final response = await _httpHelper
              .post('http://localhost:8081/api/v1/users/createUser');
          print(_credentials!.accessToken);
          print(response.statusCode);
        }
      },
    );
  }

  @override
  Future<bool> isPremium() async {
    if (_credentials?.idToken == null) return false;

    final Map<String, dynamic> decodedToken =
        JwtDecoder.decode(_credentials!.idToken);
    final roles =
        decodedToken['https://finalSistemasDistribuidos/roles'] as List?;

    return roles?.contains('PremiumUser') ?? false;
  }
}
