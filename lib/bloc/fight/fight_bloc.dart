import 'package:flutter_bloc/flutter_bloc.dart';


import '../../model/enums.dart';
import '../../model/fight.dart';
import '../../service/database_service.dart';
import 'fight_event.dart';
import 'fight_state.dart';

class FightBloc extends Bloc<FightEvent, FightState> {
  final DatabaseService databaseService;

  Fight? _fight;

  FightBloc(this.databaseService) : super(FightLoading()) {
    on<InitializeFightEvent>(_onInitializeFightEvent);
    on<CreateFightEvent>(_onCreateFightEvent);
    on<AddCharacterEvent>(_onAddCharacterEvent);
    on<OpenAddCharacterDialogEvent>(_onOpenAddCharacterDialogEvent);
  }

  Future<void> _onInitializeFightEvent(InitializeFightEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    if(_fight == null){
      emit(NoFightState());
      return;
    }
    emit(FightLoaded(_fight!));
  }

  Future<void> _onCreateFightEvent(CreateFightEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    try {
      emit(FightLoaded(event.fight));
    } catch (e) {
      emit(FightError("Impossible de créer un combat: ${e.toString()}"));
    }
  }

  Future<void> _onOpenAddCharacterDialogEvent(OpenAddCharacterDialogEvent event, Emitter<FightState> emit) async {
    emit(OpenAddCharacterDialog(event.teamType));
  }

  Future<void> _onAddCharacterEvent(AddCharacterEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    if(_fight == null){
      emit(FightError("Impossible d'ajouter un personnage à un combat non initialisé"));
      return;
    }
    if(event.teamType == TeamType.allies) {
      _fight!.allies.add(event.character);
    }
    else if(event.teamType == TeamType.enemies){
      _fight!.enemies.add(event.character);
    }
    emit(FightLoaded(_fight!));
  }
}
