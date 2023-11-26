import 'package:equatable/equatable.dart';

import '../../model/weapon.dart';

abstract class WeaponsEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AddWeaponEvent extends WeaponsEvent {
  final Weapon weapon;

  AddWeaponEvent(this.weapon);

  @override
  List<Object> get props => [weapon];
}

class EditWeaponEvent extends WeaponsEvent {
  final Weapon weapon;

  EditWeaponEvent(this.weapon);

  @override
  List<Object> get props => [weapon];
}

class LoadWeapons extends WeaponsEvent {

}