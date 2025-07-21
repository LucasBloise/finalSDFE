import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:final_sd_front/infrastructure/environments_config.dart';

class AuthService implements IAuthService {
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
      await auth0.logout();
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<void> init() async {
    await auth0.onLoad().then((final credentials) => print(credentials));
  }
}
