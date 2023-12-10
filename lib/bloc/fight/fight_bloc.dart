import 'package:djd_kids/model/weapon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../constants.dart';
import '../../model/character.dart';
import '../../model/enums.dart';
import '../../model/fight.dart';
import '../../service/character_service.dart';
import '../../service/database_service.dart';
import '../../service/ability_service.dart';
import 'fight_event.dart';
import 'fight_state.dart';

class FightBloc extends Bloc<FightEvent, FightState> {
  final DatabaseService databaseService;
  final CharacterService characterService;
  final AbilityService abilityService;

  Fight? _fight;
  Character? _selectedCharacter;
  Character? _targetedCharacter;
  bool _cacModeEnabled=false;
  bool _distModeEnabled=false;
  bool _magicModeEnabled=false;

  FightBloc(this.databaseService, this.abilityService, this.characterService) : super(FightLoading()) {
    on<InitializeFightEvent>(_onInitializeFightEvent);
    on<CreateFightEvent>(_onCreateFightEvent);
    on<AddCharacterEvent>(_onAddCharacterEvent);
    on<SelectCharacterEvent>(_onSelectCharacterEvent);
    on<SelectCacAttackEvent>(_onSelectCacAttackEvent);
    on<SelectDistAttackEvent>(_onSelectDistAttackEvent);
    on<SelectMagicAttackEvent>(_onSelectMagicAttackEvent);
    on<SelectTargetedCharacterEvent>(_onSelectTargetedCharacterEvent);
    on<OpenAttackDialogEvent>(_onOpenAttackDialogEvent);
    on<OpenEditCharacterDialogEvent>(_onOpenEditCharacterDialogEvent);
    on<EditCharacterEvent>(_onEditCharacterEvent);
    on<ResolveAttackEvent>(_onResolveAttackEvent);
  }

  Future<void> _onInitializeFightEvent(InitializeFightEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    _fight = await databaseService.searchFight();

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
      await databaseService.insertFight(event.fight);
      _fight = await databaseService.searchFight();
      emit(FightLoaded(_fight!));
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
    newCharacter.hpCurrent = newCharacter.hpMax;
    abilityService.initiativeThrow(newCharacter);

    if(event.teamType == TeamType.allies) {
      _fight!.allies.add(newCharacter);
    }
    else if(event.teamType == TeamType.enemies){
      _fight!.enemies.add(newCharacter);
    }
    if(newCharacter.cacWeapon==null){
      Weapon? cacWeapon = await databaseService.getWeaponByName("Mains nues");
      if(null!=cacWeapon){
        newCharacter.cacWeapon = cacWeapon;
      }
    }
    await databaseService.addCharacterToFight(_fight!.id!, newCharacter, event.teamType);
    _fight= await databaseService.searchFight();
    _setFightInitiative();
    emit(FightLoaded(_fight!));
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
    if(event.character==_selectedCharacter){
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
    else if(event.targetedCharacter==_targetedCharacter){
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

  void _onOpenAttackDialogEvent(OpenAttackDialogEvent event, Emitter<FightState> emit) {
    emit(FightLoading());
    emit(OpenAttackDialogState(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
  }

  void _onOpenEditCharacterDialogEvent(OpenEditCharacterDialogEvent event, Emitter<FightState> emit) {
    emit(FightLoading());
    emit(OpenEditCharacterDialogState(_fight!, _selectedCharacter!, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
  }

  Future<void> _onEditCharacterEvent(EditCharacterEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    if(event.character.cacWeapon==null){
      Weapon? cacWeapon = await databaseService.getWeaponByName("Mains nues");
      if(null!=cacWeapon){
        event.character.cacWeapon = cacWeapon;
      }
    }
    await databaseService.updateFightCharacter(event.character);
    emit(FightLoadedWithSelectedCharacter(_fight!, event.character, _cacModeEnabled, _distModeEnabled, _magicModeEnabled, _targetedCharacter));
  }

  Future<void> _onResolveAttackEvent(ResolveAttackEvent event, Emitter<FightState> emit) async {
    emit(FightLoading());
    characterService.reduceHp(_targetedCharacter!,  event.totalDegats);
    await databaseService.updateFightCharacter(_targetedCharacter!);
    _selectedCharacter=null;
    _targetedCharacter=null;
     _cacModeEnabled=false;
    _distModeEnabled=false;
    _magicModeEnabled=false;
    emit(FightLoaded(_fight!));
  }


}
