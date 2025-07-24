import 'package:final_sd_front/features/favorites/services/i_favorite_service.dart';
import 'package:final_sd_front/features/home/data/character.dart';
import 'package:final_sd_front/features/home/services/i_character_service.dart';
import 'package:flutter/material.dart';

class FavoritesViewModel extends ChangeNotifier {
  final IFavoriteService _favoriteService;
  final ICharacterService _characterService;

  FavoritesViewModel(
      {required IFavoriteService favoriteService,
      required ICharacterService characterService})
      : _favoriteService = favoriteService,
        _characterService = characterService;

  List<Character> _favoriteCharacters = [];
  List<Character> get favoriteCharacters => _favoriteCharacters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getFavoriteCharacters() async {
    _isLoading = true;
    notifyListeners();

    final favorites = await _favoriteService.getFavorites();
    final characterIds = favorites.map((fav) => fav.characterId).toList();

    if (characterIds.isNotEmpty) {
      _favoriteCharacters =
          await _characterService.getCharactersByIds(characterIds);
    } else {
      _favoriteCharacters = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
