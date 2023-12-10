import 'package:equatable/equatable.dart';

import '../../model/character.dart';

abstract class CharactersEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AddCharacterEvent extends CharactersEvent {
  final Character character;

  AddCharacterEvent(this.character);

  @override
  List<Object> get props => [character];
}

class EditCharacterEvent extends CharactersEvent {
  final Character character;

  EditCharacterEvent(this.character);

  @override
  List<Object> get props => [character];
}

class LoadCharacters extends CharactersEvent {

}