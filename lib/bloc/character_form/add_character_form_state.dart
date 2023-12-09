import 'package:djd_kids/model/creature.dart';
import 'package:equatable/equatable.dart';

import '../../model/character.dart';
import '../../model/enums.dart';
import '../../model/weapon.dart';

abstract class AddCharacterFormState extends Equatable{}

class FormLoading extends AddCharacterFormState {
  @override
  List<Object?> get props => [];
}

class FormLoaded extends AddCharacterFormState {
  final CharacterCreationType characterCreationType;
  final Character character;
  final Character? fromCharacter;
  final Creature? fromCreature;
  final List<Character> characters;
  final List<Creature> creatures;
  List<Weapon> cacWeapons;
  List<Weapon> distWeapons;
  FormLoaded(this.character, this.characters, this.creatures, this.characterCreationType, this.fromCharacter, this.fromCreature, this.cacWeapons, this.distWeapons);

  @override
  List<Object?> get props => [character, characters, creatures, characterCreationType, fromCharacter, fromCreature, cacWeapons, distWeapons];
}

class FormErrorState extends AddCharacterFormState {
  final String message;
  FormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
