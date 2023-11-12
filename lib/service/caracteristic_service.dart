import 'package:djd_kids/model/character.dart';
import 'package:djd_kids/model/creature.dart';

import 'dice_service.dart';

class CaracteristicService {

  final DiceService _diceService = DiceService();

  void initiativeThrow(Character character) {
    character.initiative= dexterityTest(character);
  }

  int defineHpMax(Creature creature) {
    int diceResult = _diceService.rollDice(creature.diceHpNumber, creature.diceHpValue);
    return diceResult + creature.diceHpBonus;
  }

  int dexterityTest(Character character) {
    return caracteristicTest(character.dexterity);
  }

  int caracteristicTest(int carac) {
    int modifier = getModifier(carac);
    int diceResult = _diceService.rollDice(1, 20);
    return diceResult + modifier;
  }

  int getModifier(int dexterity) {
    return (dexterity - 10).isEven ? (dexterity - 10) ~/ 2 : (dexterity - 11) ~/ 2;
  }



}
