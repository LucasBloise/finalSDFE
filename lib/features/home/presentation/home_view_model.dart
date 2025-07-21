import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final IAuthService _authService;

  HomeViewModel({required IAuthService authService})
      : _authService = authService;

  Future<void> initAuth0() async {
    await _authService.init();
    notifyListeners();
  }

  Future<void> signIn() async {
    await _authService.signIn();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
