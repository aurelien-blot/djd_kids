import 'package:djd_kids/constants.dart';
import 'package:equatable/equatable.dart';

abstract class AttackDialogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitializeAttackDialogEvent extends AttackDialogEvent {
  InitializeAttackDialogEvent();

  @override
  List<Object> get props => [];
}

class UpdateMJModifierEvent extends AttackDialogEvent {
  int modifier;

  UpdateMJModifierEvent(this.modifier);

  @override
  List<Object> get props => [modifier];
}

class UpdateCacAbilityEvent extends AttackDialogEvent {
  CacAbility cacAbility;

  UpdateCacAbilityEvent(this.cacAbility);

  @override
  List<Object> get props => [cacAbility];
}

class UpdateTouchDiceResultEvent extends AttackDialogEvent {
  String touchDiceResultS;

  UpdateTouchDiceResultEvent(this.touchDiceResultS);

  @override
  List<Object> get props => [touchDiceResultS];
}

class ResolveTouchDiceEvent extends AttackDialogEvent {
  ResolveTouchDiceEvent();

  @override
  List<Object> get props => [];
}

class ResolveDegatsDiceEvent extends AttackDialogEvent {
  int degatsDiceResult;
  ResolveDegatsDiceEvent(this.degatsDiceResult);

  @override
  List<Object> get props => [degatsDiceResult];
}