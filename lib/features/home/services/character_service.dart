import 'dart:convert';

import 'package:final_sd_front/features/home/data/character.dart';
import 'package:final_sd_front/features/home/services/i_character_service.dart';
import 'package:final_sd_front/integrations/http_helper/i_http_helper.dart';

class CharacterService implements ICharacterService {
  final IHttpHelper _httpHelper;

  CharacterService({required IHttpHelper httpHelper})
      : _httpHelper = httpHelper;

  @override
  Future<List<Character>> getCharacters() async {
    final response =
        await _httpHelper.get('http://localhost:8081/api/characters');

    dynamic data = response.data;
    if (data is String && data.isNotEmpty) {
      data = json.decode(data);
    }

    final results = data['results'] as List;

    return results.map((json) => Character.fromJson(json)).toList();
  }

  @override
  Future<List<Character>> getCharactersByIds(List<int> ids) async {
    final response = await _httpHelper
        .get('https://rickandmortyapi.com/api/character/${ids.join(',')}');

    List<dynamic> results;
    if (response.data is String && (response.data as String).isNotEmpty) {
      results = json.decode(response.data);
    } else if (response.data is List) {
      results = response.data;
    } else {
      results = [];
    }

    return results.map((json) => Character.fromJson(json)).toList();
  }
}
