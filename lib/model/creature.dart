import '../constants.dart';

class Creature {
  int? id;
  String? name;
  int strength; // Force
  int dexterity; // Dextérité
  int constitution; // Constitution
  int intelligence; // Intelligence
  int wisdom; // Sagesse
  int charisma; // Charisme
  int diceHpNumber;
  int diceHpValue;
  int diceHpBonus;
  int ca;
  CacAbility cacAbility;

  String get hpDetails => '${diceHpNumber}d$diceHpValue+$diceHpBonus';

  Creature({
    this.name,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.diceHpNumber,
    required this.diceHpValue,
    required this.diceHpBonus,
    required this.ca,
    required this.cacAbility,
    this.id
  });

  static Creature initCreature(String name){
    return Creature(name: name, strength: 0, dexterity: 0,
        constitution: 0, intelligence: 0, wisdom: 0, charisma: 0, diceHpNumber: 0,
        diceHpValue: 0, diceHpBonus: 0, ca: 0, cacAbility: CacAbility.FOR);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'strength' :strength,
      'dexterity' :dexterity,
      'constitution' :constitution,
      'intelligence' :intelligence,
      'wisdom' :wisdom,
      'charisma' :charisma,
      'diceHpNumber' :diceHpNumber,
      'diceHpValue' :diceHpValue,
      'diceHpBonus' :diceHpBonus,
      'cacAbility' :cacAbility.name,
      'ca' :ca,
    };
  }

  Creature.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    name = map['name'],
    strength = map['strength']??0,
    dexterity = map['dexterity']??0,
    constitution = map['constitution']??0,
    intelligence = map['intelligence']??0,
    wisdom = map['wisdom']??0,
    charisma = map['charisma']??0,
    diceHpNumber = map['diceHpNumber']??0,
    diceHpValue = map['diceHpValue']??0,
    diceHpBonus = map['diceHpBonus']??0,
    cacAbility = map['cacAbility'] != null? CacAbility.values.firstWhere((element) => element.name == map['cacAbility'],orElse: () => CacAbility.FOR): CacAbility.FOR,
    ca = map['ca']??0
  ;
}
