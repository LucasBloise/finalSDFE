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

    final results = response.data['results'] as List;

    return results.map((json) => Character.fromJson(json)).toList();
  }
}
