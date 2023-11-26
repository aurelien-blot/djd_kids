import 'package:djd_kids/model/weapon.dart';

import '../constants.dart';

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
  CacAbility cacAbility;
  Weapon? cacWeapon;
  int? cacWeaponId;
  Weapon? distWeapon;
  int? distWeaponId;

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
    required this.cacAbility,
    this.initiative,
    this.id,
    this.cacWeapon,
    this.distWeapon,
    this.cacWeaponId,
    this.distWeaponId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creatureName': creatureName,
      'creatureId': creatureId,
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
      'cacAbility' :cacAbility.name,
      'cacWeaponId' :cacWeapon?.id,
      'distWeaponId' :distWeapon?.id,
      //'cacWeapon' : cacWeapon?.toMap(),
      //'distWeapon' : distWeapon?.toMap(),
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
    cacAbility = map['cacAbility']!=null?CacAbility.values.where((element) => element.name == map['cacAbility']).first:CacAbility.FOR,
    cacWeaponId = map['cacWeaponId'],
    distWeaponId = map['distWeaponId'],
    //cacWeapon = map['cacWeapon']!=null?Weapon.fromMap(map['cacWeapon']):null,
    //distWeapon = map['distWeapon']!=null?Weapon.fromMap(map['distWeapon']):null,
    initiative = map['initiative'];
}
