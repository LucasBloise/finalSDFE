abstract class IAuthService {
  Future<void> init();
  Future<void> signIn();
  Future<void> signOut();
  Future<bool> isAuthenticated();
}
