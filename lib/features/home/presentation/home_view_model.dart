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

  Future<void> initAuth0() async {
    await _authService.init();
    notifyListeners();
  }

  Future<void> getCharacters() async {
    _characters = await _characterService.getCharacters();
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
