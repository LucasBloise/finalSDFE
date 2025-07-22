import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:final_sd_front/infrastructure/environments_config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService implements IAuthService {
  Credentials? _credentials;
  Auth0Web auth0 = Auth0Web(
    EnvironmentConfig.auth0Domain,
    EnvironmentConfig.auth0ClientId,
  );

  @override
  Future<void> signIn() async {
    try {
      await auth0.loginWithRedirect(
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
    await auth0
        .onLoad()
        .then((final credentials) => _credentials = credentials);
  }

  @override
  Future<bool> isPremium() async {
    if (_credentials?.idToken == null) return false;

    final Map<String, dynamic> decodedToken =
        JwtDecoder.decode(_credentials!.idToken);
    final roles = decodedToken['https://finalSistemasDistribuidos/roles'] as List?;

    return roles?.contains('PremiumUser') ?? false;
  }
}
