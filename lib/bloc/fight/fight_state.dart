import 'package:equatable/equatable.dart';
import '../../model/character.dart';
import '../../model/fight.dart';

abstract class FightState extends Equatable{}

class FightLoading extends FightState {
  @override
  List<Object> get props => [];
}

class NoFightState extends FightState {
  @override
  List<Object> get props => [];
}

class FightLoaded extends FightState {
  final Fight fight;
  FightLoaded(this.fight);

  @override
  List<Object> get props => [fight];
}

class FightLoadedWithSelectedCharacter extends FightLoaded {
  final Character selectedCharacter;
  final Character? targetedCharacter;
  final bool cacModeEnabled;
  final bool distModeEnabled;
  final bool magicModeEnabled;

  FightLoadedWithSelectedCharacter(super.fight,  this.selectedCharacter, this.cacModeEnabled, this.distModeEnabled, this.magicModeEnabled, this.targetedCharacter);

  bool get isActionSelected => cacModeEnabled || distModeEnabled || magicModeEnabled;

  @override
  List<Object> get props => [fight, selectedCharacter, cacModeEnabled, distModeEnabled, magicModeEnabled];
}

class FightError extends FightState with EquatableMixin {
  final String? message;

  FightError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}