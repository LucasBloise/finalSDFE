import 'package:final_sd_front/features/favorites/services/i_favorite_service.dart';
import 'package:final_sd_front/features/home/data/character.dart';
import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:final_sd_front/features/home/services/i_character_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final IAuthService _authService;
  final ICharacterService _characterService;
  final IFavoriteService _favoriteService;

  HomeViewModel({
    required IAuthService authService,
    required ICharacterService characterService,
    required IFavoriteService favoriteService,
  })  : _authService = authService,
        _characterService = characterService,
        _favoriteService = favoriteService;

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

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
    if (_isAuthenticated) {
      _isPremium = await _authService.isPremium();
    }
    notifyListeners();
  }

  Future<void> checkPremium() async {
    _isPremium = await _authService.isPremium();
    notifyListeners();
  }

  Future<void> addFavorite(Character character) async {
    await _favoriteService.addFavorite(character.id);
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
