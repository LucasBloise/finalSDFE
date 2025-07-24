import 'package:final_sd_front/features/favorites/data/favorite.dart';

abstract class IFavoriteService {
  Future<List<Favorite>> getFavorites();
  Future<void> addFavorite(int characterId);
}
