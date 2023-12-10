import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/database_service.dart';
import 'characters_event.dart';
import 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final DatabaseService databaseService;

  CharactersBloc(this.databaseService) : super(CharactersLoading()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<AddCharacterEvent>(_onAddCharacter);
    on<EditCharacterEvent>(_onEditCharacter);
  }

  Future<void> _onLoadCharacters(LoadCharacters event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());
    try {
      final characters = await databaseService.getCharacters();
      emit(CharactersLoaded(characters));
    } catch (e) {
      emit(CharactersError("Impossible de charger les personnages : ${e.toString()}"));
    }
  }

  Future<void> _onAddCharacter(AddCharacterEvent event, Emitter<CharactersState> emit) async {
    try {
      await databaseService.insertCharacter(event.character);
      final characters = await databaseService.getCharacters();
      emit(CharactersLoaded(characters));
    } catch (e) {
      emit(CharactersError("Impossible d'ajouter la personnage: ${e.toString()}"));
    }
  }

  Future<void> _onEditCharacter(EditCharacterEvent event, Emitter<CharactersState> emit) async {
    try {
      // Suppose you have a method in your DatabaseService to update a character
      await databaseService.updateCharacter(event.character);
      final characters = await databaseService.getCharacters();
      emit(CharactersLoaded(characters));
    } catch (e) {
      emit(CharactersError("Impossible de modifier la personnage: ${e.toString()}"));
    }
  }
}
