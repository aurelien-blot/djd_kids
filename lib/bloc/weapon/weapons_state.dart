import 'package:equatable/equatable.dart';

import '../../model/weapon.dart';

abstract class WeaponsState {}

class WeaponsLoading extends WeaponsState {}

class WeaponsLoaded extends WeaponsState {
  final List<Weapon> weapons;
  WeaponsLoaded(this.weapons);
}

class WeaponsError extends WeaponsState with EquatableMixin {
  final String? message;

  WeaponsError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}