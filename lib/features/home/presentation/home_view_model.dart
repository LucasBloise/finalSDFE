import 'package:final_sd_front/features/home/data/character.dart';
import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:final_sd_front/features/home/services/i_character_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final IAuthService _authService;
  final ICharacterService _characterService;

  HomeViewModel({
    required IAuthService authService,
    required ICharacterService characterService,
  })  : _authService = authService,
        _characterService = characterService;

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initAuth0() async {
    await _authService.init();
    await checkAuthentication();
    notifyListeners();
  }

  Future<void> getCharacters() async {
    _isLoading = true;
    notifyListeners();

    _characters = await _characterService.getCharacters();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkAuthentication() async {
    _isAuthenticated = await _authService.isAuthenticated();
    notifyListeners();
  }

  Future<void> signIn() async {
    await _authService.signIn();
    await checkAuthentication();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await checkAuthentication();
    notifyListeners();
  }
}
