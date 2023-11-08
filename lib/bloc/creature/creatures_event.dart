import 'package:equatable/equatable.dart';

import '../../model/creature.dart';

abstract class CreaturesEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AddCreatureEvent extends CreaturesEvent {
  final Creature creature;

  AddCreatureEvent(this.creature);

  @override
  List<Object> get props => [creature];
}

class EditCreatureEvent extends CreaturesEvent {
  final Creature creature;

  EditCreatureEvent(this.creature);

  @override
  List<Object> get props => [creature];
}

class LoadCreatures extends CreaturesEvent {

}