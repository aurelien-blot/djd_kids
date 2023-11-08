import 'package:equatable/equatable.dart';

import '../../model/creature.dart';

abstract class CreaturesState {}

class CreaturesLoading extends CreaturesState {}

class CreaturesLoaded extends CreaturesState {
  final List<Creature> creatures;
  CreaturesLoaded(this.creatures);
}

class CreaturesError extends CreaturesState with EquatableMixin {
  final String? message;

  CreaturesError(this.message);

  @override
  List<Object> get props => [message??'Erreur inconnue'];
}