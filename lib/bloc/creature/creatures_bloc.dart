import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/database_service.dart';
import 'creatures_event.dart';
import 'creatures_state.dart';

class CreaturesBloc extends Bloc<CreaturesEvent, CreaturesState> {
  final DatabaseService databaseService;

  CreaturesBloc(this.databaseService) : super(CreaturesLoading()) {
    on<LoadCreatures>(_onLoadCreatures);
    on<AddCreatureEvent>(_onAddCreature);
    on<EditCreatureEvent>(_onEditCreature);
  }

  Future<void> _onLoadCreatures(LoadCreatures event, Emitter<CreaturesState> emit) async {
    emit(CreaturesLoading());
    try {
      final creatures = await databaseService.getCreatures();
      emit(CreaturesLoaded(creatures));
    } catch (e) {
      emit(CreaturesError("Impossible de charger les créatures : ${e.toString()}"));
    }
  }

  Future<void> _onAddCreature(AddCreatureEvent event, Emitter<CreaturesState> emit) async {
    try {
      await databaseService.insertCreature(event.creature);
      final creatures = await databaseService.getCreatures();
      emit(CreaturesLoaded(creatures));
    } catch (e) {
      emit(CreaturesError("Impossible d'ajouter la créature: ${e.toString()}"));
    }
  }

  Future<void> _onEditCreature(EditCreatureEvent event, Emitter<CreaturesState> emit) async {
    try {
      // Suppose you have a method in your DatabaseService to update a creature
      await databaseService.updateCreature(event.creature);
      final creatures = await databaseService.getCreatures();
      emit(CreaturesLoaded(creatures));
    } catch (e) {
      emit(CreaturesError("Impossible de modifier la créature: ${e.toString()}"));
    }
  }
}
