import 'package:djd_kids/constants.dart';
import 'package:equatable/equatable.dart';

import '../../model/character.dart';
import '../../model/creature.dart';
import '../../model/enums.dart';
import '../../model/weapon.dart';

abstract class AddCharacterFormEvent extends Equatable{}

class InitializeAddCharacterFormEvent extends AddCharacterFormEvent {
  @override
  List<Object?> get props => [];
}

class CreationTypeChangeEvent extends AddCharacterFormEvent {
  final CharacterCreationType characterCreationType;
  CreationTypeChangeEvent(this.characterCreationType);

  @override
  List<Object?> get props => [characterCreationType];
}

class SelectCharacter extends AddCharacterFormEvent {
  final Character character;
  SelectCharacter(this.character);

  @override
  List<Object?> get props => [character];
}

class SelectCreature extends AddCharacterFormEvent {
  final Creature creature;
  SelectCreature(this.creature);

  @override
  List<Object?> get props => [creature];
}

class SelectCacWeapon extends AddCharacterFormEvent {
  final Weapon? weapon;
  SelectCacWeapon(this.weapon);

  @override
  List<Object?> get props => [weapon];
}

class SelectDistWeapon extends AddCharacterFormEvent {
  final Weapon? weapon;
  SelectDistWeapon(this.weapon);

  @override
  List<Object?> get props => [weapon];
}

class SelectCacAbility extends AddCharacterFormEvent {
  final CacAbility cacAbility;
  SelectCacAbility(this.cacAbility);

  @override
  List<Object?> get props => [cacAbility];
}
