import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../model/character.dart';
import '../../service/ability_service.dart';
import 'attack_dialog_event.dart';
import 'attack_dialog_state.dart';

class AttackDialogBloc extends Bloc<AttackDialogEvent, AttackDialogState> {
  final Character defender;
  final Character attacker;
  final AbilityService abilityService;
  final AttackType attackType;

  AttackResult? _attackResult;
  int _modifier = 0;
  int? _touchDiceResult;
  final List<int> _modifierList = List.generate(21, (index) => -10 + index);
  final List<int> _diceFacesList = List.generate(20, (index) => index);
  CacAbility _cacAbility = CacAbility.FOR;
  int _abilityModifier = 0;
  int _totalDegats = 0;

  AttackDialogBloc(this.abilityService, this.attacker, this.defender, this.attackType) : super(AttackDialogLoading()) {
    on<InitializeAttackDialogEvent>(_onInitializeAttackDialogEvent);
    on<UpdateMJModifierEvent>(_onUpdateMJModifierEvent);
    on<UpdateCacAbilityEvent>(_onUpdateCacAbilityEvent);
    on<UpdateTouchDiceResultEvent>(_onUpdateTouchDiceResultEvent);
    on<ResolveTouchDiceEvent>(_onResolveTouchDiceEvent);
    on<ResolveDegatsDiceEvent>(_onResolveDegatsDiceEvent);

  }

  Future<void> _onInitializeAttackDialogEvent(InitializeAttackDialogEvent event, Emitter<AttackDialogState> emit) async {
    emit(AttackDialogLoading());
    try {
      if(attackType==AttackType.RANGED){
        _cacAbility = CacAbility.DEX;
      }
      else{
        _cacAbility = attacker.cacAbility;
      }

      _defineAbilityModifier();
      emit(AttackDialogLoaded(_modifier, _cacAbility, _diceFacesList,_modifierList,  _touchDiceResult, _abilityModifier));
    } catch (e) {
      emit(AttackDialogError("Impossible de charger les créatures : ${e.toString()}"));
    }
  }

  void _defineAbilityModifier(){
    if(_cacAbility == CacAbility.FOR){
      _abilityModifier = abilityService.getModifier(attacker.strength);
    }
    else if(_cacAbility == CacAbility.DEX){
      _abilityModifier = abilityService.getModifier(attacker.dexterity);
    }
    else{
      _abilityModifier = 0;
    }
  }

  void _onUpdateMJModifierEvent(UpdateMJModifierEvent event, Emitter<AttackDialogState> emit) async {
      _modifier = event.modifier;
      emit(AttackDialogLoaded(_modifier, _cacAbility, _diceFacesList,_modifierList,  _touchDiceResult, _abilityModifier));
  }
  void _onUpdateCacAbilityEvent(UpdateCacAbilityEvent event, Emitter<AttackDialogState> emit) async {
      _cacAbility = event.cacAbility;
      _defineAbilityModifier();
      emit(AttackDialogLoaded(_modifier, _cacAbility, _diceFacesList,_modifierList,  _touchDiceResult, _abilityModifier));
  }
  void _onUpdateTouchDiceResultEvent(UpdateTouchDiceResultEvent event, Emitter<AttackDialogState> emit) async {
      emit(AttackDialogLoading());
      try{
        _touchDiceResult = int.tryParse(event.touchDiceResultS);
        emit(AttackDialogLoaded(_modifier, _cacAbility, _diceFacesList,_modifierList,  _touchDiceResult, _abilityModifier));
      }
      catch(e){
        emit(AttackDialogError("Impossible de convertir le résultat du dé de touché : ${e.toString()}"));
      }
  }

  void _onResolveTouchDiceEvent(ResolveTouchDiceEvent event, Emitter<AttackDialogState> emit) async {
      emit(AttackDialogLoading());
      _attackResult = abilityService.isAttackSuccessful(_modifier, _touchDiceResult!, _abilityModifier, defender.ca);
      emit(DiceThrowedState(_modifier, _cacAbility, _diceFacesList,_modifierList,  _touchDiceResult, _abilityModifier, _attackResult!));
  }
  void _onResolveDegatsDiceEvent(ResolveDegatsDiceEvent event, Emitter<AttackDialogState> emit) async {
      emit(AttackDialogLoading());
      _totalDegats = event.degatsDiceResult;
      emit(FinalResultState(_modifier, _cacAbility, _diceFacesList,_modifierList,  _touchDiceResult, _abilityModifier, _totalDegats));
  }
}
