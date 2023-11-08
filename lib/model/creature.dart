class Creature {
  int? id;
  String? name;
  int strength; // Force
  int dexterity; // Dextérité
  int constitution; // Constitution
  int intelligence; // Intelligence
  int wisdom; // Sagesse
  int charisma; // Charisme

  Creature({
    this.name,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    this.id
  });

  static Creature initCreature(String name){
    return Creature(name: name, strength: 0, dexterity: 0, constitution: 0, intelligence: 0, wisdom: 0, charisma: 0);
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
    charisma = map['charisma']??0;


}
