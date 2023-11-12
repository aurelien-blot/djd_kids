import 'package:equatable/equatable.dart';

import '../../model/character.dart';
import '../../model/creature.dart';
import '../../model/enums.dart';

abstract class CharacterFormEvent extends Equatable{}

class InitializeCharacterFormEvent extends CharacterFormEvent {
  @override
  List<Object?> get props => [];
}

class CreationTypeChangeEvent extends CharacterFormEvent {
  final CharacterCreationType characterCreationType;
  CreationTypeChangeEvent(this.characterCreationType);

  @override
  List<Object?> get props => [characterCreationType];
}

class SelectCharacter extends CharacterFormEvent {
  final Character character;
  SelectCharacter(this.character);

  @override
  List<Object?> get props => [character];
}

class SelectCreature extends CharacterFormEvent {
  final Creature creature;
  SelectCreature(this.creature);

  @override
  List<Object?> get props => [creature];
}
