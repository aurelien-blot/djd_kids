import 'package:equatable/equatable.dart';

import '../../model/character.dart';
import '../../model/enums.dart';
import '../../model/fight.dart';

abstract class FightEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class InitializeFightEvent extends FightEvent {

}
class CreateFightEvent extends FightEvent {
  final Fight fight;
  CreateFightEvent(this.fight);

  @override
  List<Object> get props => [fight];
}

class AddCharacterEvent extends FightEvent {
  final TeamType teamType;
  final Character character;
  AddCharacterEvent(this.teamType, this.character);

  @override
  List<Object> get props => [teamType, character];
}

class SelectCharacterEvent extends FightEvent {
  final Character character;

  SelectCharacterEvent(this.character);
}

class SelectTargetedCharacterEvent extends FightEvent {
  final Character targetedCharacter;

  SelectTargetedCharacterEvent(this.targetedCharacter);
}

class SelectCacAttackEvent extends FightEvent {
  SelectCacAttackEvent();
}

class SelectDistAttackEvent extends FightEvent {
  SelectDistAttackEvent();
}

class SelectMagicAttackEvent extends FightEvent {
  SelectMagicAttackEvent();
}

class OpenAttackDialogEvent extends FightEvent {
  OpenAttackDialogEvent();
}

class ResolveAttackEvent extends FightEvent {
  final int totalDegats;
  ResolveAttackEvent(this.totalDegats);

  @override
  List<Object> get props => [totalDegats];
}
