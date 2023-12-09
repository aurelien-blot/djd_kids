import '../constants.dart';

class Weapon {
  int? id;
  String? name;
  int diceDegatsNumber;
  int diceDegatsValue;
  int diceDegatsBonus;
  WeaponType weaponType;

  String get degatsDetails => '${diceDegatsNumber}d$diceDegatsValue+$diceDegatsBonus';

  String get degatsMinDetails {
    String details = '${diceDegatsNumber}d$diceDegatsValue';
    return details;
  }

  String get weaponFullLabel => '$name ($degatsMinDetails)';

  Weapon({
    this.name,
    required this.diceDegatsNumber,
    required this.diceDegatsValue,
    required this.diceDegatsBonus,
    required this.weaponType,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'diceDegatsNumber' :diceDegatsNumber,
      'diceDegatsValue' :diceDegatsValue,
      'diceDegatsBonus' :diceDegatsBonus,
      'weaponType' : weaponType.name,
    };
  }

  Weapon.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    name = map['name'],
    diceDegatsNumber = map['diceDegatsNumber']??0,
    diceDegatsValue = map['diceDegatsValue']??0,
    diceDegatsBonus = map['diceDegatsBonus']??0,
    weaponType = map['weaponType']!=null?WeaponType.values.where((element) => element.name == map['weaponType']).first:WeaponType.UNKNOW
  ;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Weapon && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
