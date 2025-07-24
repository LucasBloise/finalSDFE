import 'dart:convert';

import 'package:final_sd_front/features/favorites/data/favorite.dart';
import 'package:final_sd_front/features/favorites/services/i_favorite_service.dart';
import 'package:final_sd_front/integrations/http_helper/i_http_helper.dart';

class FavoriteService implements IFavoriteService {
  final IHttpHelper _httpHelper;

  FavoriteService({required IHttpHelper httpHelper}) : _httpHelper = httpHelper;

  @override
  Future<List<Favorite>> getFavorites() async {
    final response =
        await _httpHelper.get('http://localhost:8081/api/v1/users/favorites');

    List<dynamic> results;
    if (response.data is String && (response.data as String).isNotEmpty) {
      results = json.decode(response.data);
    } else if (response.data is List) {
      results = response.data;
    } else {
      results = [];
    }

    print(results);
    return results.map((json) => Favorite.fromJson(json)).toList();
  }

  @override
  Future<void> addFavorite(int characterId) async {
    await _httpHelper.post(
      'http://localhost:8081/api/v1/users/favorites',
      data: {'characterId': characterId},
    );
  }
}
