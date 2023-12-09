import 'package:djd_kids/model/enums.dart';
import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/service/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../model/character.dart';
import '../../model/creature.dart';
import '../../model/weapon.dart';
import 'add_character_form_event.dart';
import 'add_character_form_state.dart';

class AddCharacterFormBloc extends Bloc<AddCharacterFormEvent, AddCharacterFormState> {

  final DatabaseService databaseService;
  final CharacterService characterService;

  Character? _character;
  List<Character> _characters = [];
  List<Creature> _creatures = [];
  List<Weapon> _cacWeapons = [];
  List<Weapon> _distWeapons = [];

  Creature? _fromCreature;
  Character? _fromCharacter;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController dexterityController = TextEditingController();
  final TextEditingController constitutionController = TextEditingController();
  final TextEditingController intelligenceController = TextEditingController();
  final TextEditingController wisdomController = TextEditingController();
  final TextEditingController charismaController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController caController = TextEditingController();


  AddCharacterFormBloc({required this.databaseService, required this.characterService}) : super(FormLoading()) {
    on<InitializeAddCharacterFormEvent>(_onInitializeAddCharacterForm);
    on<CreationTypeChangeEvent>(_onCreationTypeChangeEvent);
    on<SelectCharacter>(_onSelectCharacter);
    on<SelectCreature>(_onSelectCreature);
    on<SelectCacWeapon>(_onSelectCacWeapon);
    on<SelectDistWeapon>(_onSelectDistWeapon);
  }

  Future<void> _onInitializeAddCharacterForm(InitializeAddCharacterFormEvent event, Emitter<AddCharacterFormState> emit) async {
    emit(FormLoading());
    _character = characterService.initNewCharacter();
    _characters = await databaseService.getCharacters();
    _creatures = await databaseService.getCreatures();
    List<Weapon> weapons = await databaseService.getWeapons();
    _cacWeapons = weapons.where((element) => element.weaponType == WeaponType.MELEE || element.weaponType == WeaponType.MELEE_ET_DISTANCE).toList();
    _distWeapons = weapons.where((element) => element.weaponType == WeaponType.DISTANCE || element.weaponType == WeaponType.MELEE_ET_DISTANCE).toList();
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.character, _fromCharacter, _fromCreature, _cacWeapons, _distWeapons));
  }

  Future<void> _onCreationTypeChangeEvent(CreationTypeChangeEvent event, Emitter<AddCharacterFormState> emit) async {
    emit(FormLoading());
    _fromCreature = null;
    _fromCharacter = null;
    emit(FormLoaded(_character!, _characters, _creatures, event.characterCreationType, _fromCharacter, _fromCreature, _cacWeapons, _distWeapons));
  }

  void _updateControllersWithCharacter(Character character) {
    nameController.text = character.name;
    strengthController.text = character.strength.toString();
    dexterityController.text = character.dexterity.toString();
    constitutionController.text = character.constitution.toString();
    intelligenceController.text = character.intelligence.toString();
    wisdomController.text = character.wisdom.toString();
    charismaController.text = character.charisma.toString();
    hpController.text = character.hpMax.toString();
    caController.text = character.ca.toString();

  }

  void _onSelectCharacter(SelectCharacter event, Emitter<AddCharacterFormState> emit) {
    emit(FormLoading());
    _fromCharacter = event.character;
    _fromCreature = null;
    _character = event.character;
    _updateControllersWithCharacter(_character!);
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.character, _fromCharacter, _fromCreature, _cacWeapons, _distWeapons));
  }

  void _onSelectCreature(SelectCreature event, Emitter<AddCharacterFormState> emit) {
    emit(FormLoading());
    _fromCharacter = null;
    _fromCreature = event.creature;
    _character = characterService.initCharacter("", event.creature);
    _updateControllersWithCharacter(_character!);
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.creature, _fromCharacter, _fromCreature, _cacWeapons, _distWeapons));
  }
  void _onSelectCacWeapon(SelectCacWeapon event, Emitter<AddCharacterFormState> emit) {
    emit(FormLoading());
    _character!.cacWeapon = event.weapon;
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.creature, _fromCharacter, _fromCreature, _cacWeapons, _distWeapons));
  }

  void _onSelectDistWeapon(SelectDistWeapon event, Emitter<AddCharacterFormState> emit) {
    emit(FormLoading());
    _character!.distWeapon = event.weapon;
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.creature, _fromCharacter, _fromCreature, _cacWeapons, _distWeapons));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    strengthController.dispose();
    dexterityController.dispose();
    constitutionController.dispose();
    intelligenceController.dispose();
    wisdomController.dispose();
    charismaController.dispose();
    hpController.dispose();
    caController.dispose();

    return super.close();
  }

}
