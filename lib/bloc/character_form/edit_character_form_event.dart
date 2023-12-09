import 'package:equatable/equatable.dart';

import '../../model/character.dart';
import '../../model/creature.dart';
import '../../model/enums.dart';
import '../../model/weapon.dart';

abstract class EditCharacterFormEvent extends Equatable{}

class InitializeEditCharacterFormEvent extends EditCharacterFormEvent {
  @override
  List<Object?> get props => [];
}

class SelectCacWeapon extends EditCharacterFormEvent {
  final Weapon? weapon;
  SelectCacWeapon(this.weapon);

  @override
  List<Object?> get props => [weapon];
}

class SelectDistWeapon extends EditCharacterFormEvent {
  final Weapon? weapon;
  SelectDistWeapon(this.weapon);

  @override
  List<Object?> get props => [weapon];
}
