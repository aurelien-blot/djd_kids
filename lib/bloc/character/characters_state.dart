import 'package:equatable/equatable.dart';

import '../../model/character.dart';

abstract class CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  CharactersLoaded(this.characters);
}

class CharactersError extends CharactersState with EquatableMixin {
  final String? message;

  CharactersError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}