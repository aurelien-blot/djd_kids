import 'package:djd_kids/service/character_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../model/character.dart';
import '../../model/enums.dart';
import '../../model/fight.dart';
import '../../service/database_service.dart';
import '../../service/caracteristic_service.dart';
import 'fight_event.dart';
import 'fight_state.dart';

class FightBloc extends Bloc<FightEvent, FightState> {
  final DatabaseService databaseService;

  Fight? _fight;
  final CaracteristicService _caracteristicService = CaracteristicService();
  Character? _selectedCharacter;
  Character? _targetedCharacter=null;
  bool _cacModeEnabled=false;
  bool _distModeEnabled=false;
  bool _magicModeEnabled=false;

  FightBloc(this.databaseService) : super(FightLoading()) {
    on<InitializeFightEvent>(_onInitializeFightEvent);
    on<CreateFightEvent>(_onCreateFightEvent);
    on<AddCharacterEvent>(_onAddCharacterEvent);
    on<SelectCharacterEvent>(_onSelectCharacterEvent);
    on<SelectCacAttackEvent>(_onSelectCacAttackEvent);
    on<SelectDistAttackEvent>(_onSelectDistAttackEvent);
    on<SelectMagicAttackEvent>(_onSelectMagicAttackEvent);
    on<SelectTargetedCharacterEvent>(_onSelectTargetedCharacterEvent);
  }

  Future<void> _onInitializeFightEvent(InitializeFightEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    //TODO A RETIRER APRES TEST
    _fight = _createFightForTest();

    if(_fight == null){
      emit(NoFightState());
      return;
    }
    _setFightInitiative();
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

  Future<void> _onAddCharacterEvent(AddCharacterEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    if(_fight == null){
      emit(FightError("Impossible d'ajouter un personnage à un combat non initialisé"));
      return;
    }
    Character newCharacter = event.character;
    _caracteristicService.initiativeThrow(newCharacter);

    if(event.teamType == TeamType.allies) {
      _fight!.allies.add(newCharacter);
    }
    else if(event.teamType == TeamType.enemies){
      _fight!.enemies.add(newCharacter);
    }
    _setFightInitiative();
    emit(FightLoaded(_fight!));
  }

  Fight _createFightForTest(){
    Fight test =  Fight(name: "Combat 1", allies: [], enemies: []);
    Character character1=Character(name: "Sam", strength: 13, dexterity: 15, constitution: 16, intelligence: 18, wisdom: 20, charisma: 22, hpMax: 100, hpCurrent: 100, ca: 10);
    _caracteristicService.initiativeThrow(character1);
    Character character2=Character(name: "Félix", strength: 10, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 12, charisma: 10, hpMax: 50, hpCurrent: 30, ca : 11);
    _caracteristicService.initiativeThrow(character2);
    Character character3=Character(name: "Saroumane", strength: 11, dexterity: 10, constitution: 10, intelligence: 10, wisdom: 10, charisma: 8, hpMax: 70, hpCurrent: 7, ca : 13);
    _caracteristicService.initiativeThrow(character3);
    Character character4=Character(name: "Sauron", strength: 10, dexterity: 7, constitution: 16, intelligence: 10, wisdom: 10, charisma: 10, hpMax: 80, hpCurrent: 84, ca : 10);
    _caracteristicService.initiativeThrow(character4);
    Character character5=Character(name: "Jacques", strength: 10, dexterity: 42, constitution: 10, intelligence: 10, wisdom: 10, charisma: 26, hpMax: 53, hpCurrent: 52, ca : 15);
    _caracteristicService.initiativeThrow(character5);

    test.allies.add(character1);
    test.allies.add(character2);
    test.enemies.add(character3);
    test.enemies.add(character4);
    test.enemies.add(character5);

    return test;
  }

  void _setFightInitiative(){
    List<Character> orderedList = [];
    orderedList.addAll(_fight!.allies);
    orderedList.addAll(_fight!.enemies);
    orderedList.sort((a, b) => a.initiative == null? 1 : b.initiative == null? -1 : b.initiative!.compareTo(a.initiative!));
    _fight?.orderedByInitiative = orderedList;
  }

  Future<void> _onSelectCharacterEvent(SelectCharacterEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    _resetFightModeButtons();
    _targetedCharacter = null;
    if(event.character==null || event.character==_selectedCharacter){
      _selectedCharacter = null;
      emit(FightLoaded(_fight!));
    }
    else {
      _selectedCharacter = event.character;
      emit(FightLoadedWithSelectedCharacter(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
    }

  }

  Future<void> _onSelectCacAttackEvent(SelectCacAttackEvent event, Emitter<FightState> emit) async {
    _distModeEnabled=false;
    _magicModeEnabled=false;
    if(!_cacModeEnabled){
      _cacModeEnabled=true;
    }
    else{
      _cacModeEnabled=false;
      _targetedCharacter=null;
    }
    emit(FightLoadedWithSelectedCharacter(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));

  }
  Future<void> _onSelectDistAttackEvent(SelectDistAttackEvent event, Emitter<FightState> emit) async {
    _cacModeEnabled=false;
    _magicModeEnabled=false;
    if(!_distModeEnabled){
      _distModeEnabled=true;
    }
    else{
      _distModeEnabled=false;
      _targetedCharacter=null;
    }
    emit(FightLoadedWithSelectedCharacter(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
  }
  Future<void> _onSelectMagicAttackEvent(SelectMagicAttackEvent event, Emitter<FightState> emit) async {
    _cacModeEnabled=false;
    _distModeEnabled=false;
    if(!_magicModeEnabled){
      _magicModeEnabled=true;
    }
    else{
      _magicModeEnabled=false;
      _targetedCharacter=null;
    }
    emit(FightLoadedWithSelectedCharacter(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
  }
  Future<void> _onSelectTargetedCharacterEvent(SelectTargetedCharacterEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    if(event.targetedCharacter==_selectedCharacter){
      _selectedCharacter = null;
      _targetedCharacter = null;
      emit(FightLoaded(_fight!));
    }
    else if(event.targetedCharacter==null || event.targetedCharacter==_targetedCharacter){
      _targetedCharacter = null;
    }
    else {
      _targetedCharacter = event.targetedCharacter;
    }
    emit(FightLoadedWithSelectedCharacter(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
  }

  void _resetFightModeButtons(){
    _cacModeEnabled=false;
    _distModeEnabled=false;
    _magicModeEnabled=false;
  }

}
