import 'package:equatable/equatable.dart';
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

class FightError extends FightState with EquatableMixin {
  final String? message;

  FightError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}