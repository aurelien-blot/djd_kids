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

