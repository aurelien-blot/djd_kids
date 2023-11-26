import 'package:djd_kids/model/character.dart';
import 'package:djd_kids/model/creature.dart';

import '../constants.dart';
import 'dice_service.dart';

class AbilityService {

  final DiceService _diceService = DiceService();

  void initiativeThrow(Character character) {
    character.initiative= dexterityTest(character);
  }

  int defineHpMax(Creature creature) {
    int diceResult = _diceService.rollDice(creature.diceHpNumber, creature.diceHpValue);
    return diceResult + creature.diceHpBonus;
  }

  int dexterityTest(Character character) {
    return abilityTest(character.dexterity);
  }

  int abilityTest(int carac) {
    int modifier = getModifier(carac);
    int diceResult = _diceService.rollDice(1, 20);
    return diceResult + modifier;
  }

  int getModifier(int ability) {
    return (ability - 10).isEven ? (ability - 10) ~/ 2 : (ability - 11) ~/ 2;
  }

  AttackResult isAttackSuccessful(int mJModifier, int dice, int abilityModifer, int ca) {
    if(dice == 1){
      return AttackResult.CRITICAL_FAIL;
    }
    if(dice == 20){
      return AttackResult.CRITICAL_SUCCESS;
    }
    if((mJModifier+dice+abilityModifer) >= ca){
      return AttackResult.SUCCESS;
    }
    return AttackResult.FAIL;
  }



}
