import 'package:equatable/equatable.dart';

import '../../constants.dart';

abstract class AttackDialogState extends Equatable{}

class AttackDialogLoading extends AttackDialogState {
  @override
  List<Object> get props => [];
}

class AttackDialogLoaded extends AttackDialogState {
  int modifier;
  final List<int> modifierList ;
  final List<int> diceFacesList;
  CacAbility cacAbility;
  int? touchDiceResult;
  int abilityModifier;
  bool? isSuccess;

  AttackDialogLoaded(this.modifier, this.cacAbility, this.diceFacesList, this.modifierList, this.touchDiceResult, this.abilityModifier);

  @override
  List<Object> get props => [modifier, cacAbility, diceFacesList, modifierList, abilityModifier];
}

class DiceThrowedState extends AttackDialogLoaded {
  final AttackResult attackResult;

  DiceThrowedState(int modifier, CacAbility cacAbility, List<int> diceFacesList, List<int> modifierList, int? touchDiceResult, int abilityModifier, this.attackResult) : super(modifier, cacAbility, diceFacesList, modifierList, touchDiceResult, abilityModifier);

  @override
  List<Object> get props => [modifier, cacAbility, diceFacesList, modifierList, abilityModifier, attackResult];
}

class AttackDialogError extends AttackDialogState with EquatableMixin {
  final String? message;

  AttackDialogError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}