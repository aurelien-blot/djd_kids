class Character {
  int? id;
  String name;
  String? creatureName;
  int? creatureId;
  int strength; // Force
  int dexterity; // Dextérité
  int constitution; // Constitution
  int intelligence; // Intelligence
  int wisdom; // Sagesse
  int charisma; // Charisme
  int? initiative;
  int hpMax;
  int hpCurrent;
  int ca;

  Character({
    required this.name,
    this.creatureName,
    this.creatureId,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.hpMax,
    required this.hpCurrent,
    required this.ca,
    this.initiative,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creatureName': creatureName,
      'creatureName': creatureId,
      'strength' :strength,
      'dexterity' :dexterity,
      'constitution' :constitution,
      'intelligence' :intelligence,
      'wisdom' :wisdom,
      'charisma' :charisma,
      'initiative' :initiative,
      'hpMax' :hpMax,
      'hpCurrent' :hpCurrent,
      'ca' :ca,
    };
  }

  Character.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    name = map['name'],
    creatureName = map['creatureName'],
    creatureId = map['creatureId'],
    strength = map['strength']??0,
    dexterity = map['dexterity']??0,
    constitution = map['constitution']??0,
    intelligence = map['intelligence']??0,
    wisdom = map['wisdom']??0,
    charisma = map['charisma']??0,
    hpMax = map['hpMax']??0,
    hpCurrent = map['hpCurrent']??0,
    ca = map['ca']??0,
    initiative = map['initiative'];


}
