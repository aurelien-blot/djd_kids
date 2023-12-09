import 'package:djd_kids/model/creature.dart';
import 'package:equatable/equatable.dart';

import '../../model/character.dart';
import '../../model/enums.dart';
import '../../model/weapon.dart';

abstract class EditCharacterFormState extends Equatable{}

class FormLoading extends EditCharacterFormState {
  @override
  List<Object?> get props => [];
}

class FormLoaded extends EditCharacterFormState {
  final Character character;
  List<Weapon> cacWeapons;
  List<Weapon> distWeapons;
  FormLoaded(this.character, this.cacWeapons, this.distWeapons);

  @override
  List<Object?> get props => [character, cacWeapons, distWeapons];
}

class FormErrorState extends EditCharacterFormState {
  final String message;
  FormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
