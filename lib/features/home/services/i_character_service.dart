import 'package:final_sd_front/features/home/data/character.dart';

abstract class ICharacterService {
  Future<List<Character>> getCharacters();
}
