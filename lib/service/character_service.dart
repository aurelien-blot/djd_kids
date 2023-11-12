import 'package:djd_kids/model/character.dart';
import 'package:djd_kids/service/caracteristic_service.dart';

import '../model/creature.dart';

class CharacterService {

  final CaracteristicService _caracteristicService = CaracteristicService();

  Character initCharacter(String name, Creature creature){
    int hpMax = _caracteristicService.defineHpMax(creature);
    int hpCurrent = hpMax;
    return Character(name: name, creatureName : creature.name, creatureId: creature.id,
        strength: creature.strength, dexterity: creature.dexterity,
        constitution: creature.constitution, intelligence: creature.intelligence,
        wisdom: creature.wisdom, charisma: creature.charisma, hpMax: hpMax, hpCurrent: hpCurrent);
  }

  Character initNewCharacter(){
    return Character(name: '',strength: 0, dexterity: 0, constitution: 0, intelligence: 0, wisdom: 0, charisma: 0, hpMax: 0, hpCurrent: 0);
  }

}
