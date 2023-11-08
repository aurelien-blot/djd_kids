import 'creature.dart';

class Character {
  int? id;
  String name;
  String? creatureName;
  int strength; // Force
  int dexterity; // Dextérité
  int constitution; // Constitution
  int intelligence; // Intelligence
  int wisdom; // Sagesse
  int charisma; // Charisme

  Character({
    required this.name,
    this.creatureName,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    this.id
  });

  static Character initCharacter(String name, Creature creature){
    return Character(name: name, creatureName : creature.name,
        strength: creature.strength, dexterity: creature.dexterity,
        constitution: creature.constitution, intelligence: creature.intelligence,
        wisdom: creature.wisdom, charisma: creature.charisma);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creatureName': creatureName,
      'strength' :strength,
      'dexterity' :dexterity,
      'constitution' :constitution,
      'intelligence' :intelligence,
      'wisdom' :wisdom,
      'charisma' :charisma,
    };
  }

  Character.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    name = map['name'],
    creatureName = map['creatureName'],
    strength = map['strength']??0,
    dexterity = map['dexterity']??0,
    constitution = map['constitution']??0,
    intelligence = map['intelligence']??0,
    wisdom = map['wisdom']??0,
    charisma = map['charisma']??0;


}
