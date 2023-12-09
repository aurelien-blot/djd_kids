import 'package:djd_kids/model/enums.dart';
import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/service/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../model/character.dart';
import '../../model/creature.dart';
import '../../model/weapon.dart';
import 'edit_character_form_event.dart';
import 'edit_character_form_state.dart';

class EditCharacterFormBloc extends Bloc<EditCharacterFormEvent, EditCharacterFormState> {

  final DatabaseService databaseService;
  Character character;
  
  List<Weapon> _cacWeapons = [];
  List<Weapon> _distWeapons = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController dexterityController = TextEditingController();
  final TextEditingController constitutionController = TextEditingController();
  final TextEditingController intelligenceController = TextEditingController();
  final TextEditingController wisdomController = TextEditingController();
  final TextEditingController charismaController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController remainingHpController = TextEditingController();
  final TextEditingController caController = TextEditingController();


  EditCharacterFormBloc({required this.databaseService, required this.character}) : super(FormLoading()) {
    on<InitializeEditCharacterFormEvent>(_onInitializeEditCharacterForm);
    on<SelectCacWeapon>(_onSelectCacWeapon);
    on<SelectDistWeapon>(_onSelectDistWeapon);
  }

  Future<void> _onInitializeEditCharacterForm(InitializeEditCharacterFormEvent event, Emitter<EditCharacterFormState> emit) async {
    emit(FormLoading());
    _updateControllersWithCharacter(character);
    List<Weapon> weapons = await databaseService.getWeapons();
    _cacWeapons = weapons.where((element) => element.weaponType == WeaponType.MELEE || element.weaponType == WeaponType.MELEE_ET_DISTANCE).toList();
    _distWeapons = weapons.where((element) => element.weaponType == WeaponType.DISTANCE || element.weaponType == WeaponType.MELEE_ET_DISTANCE).toList();
    emit(FormLoaded(character, _cacWeapons, _distWeapons));
  }


  void _updateControllersWithCharacter(Character character) {
    nameController.text = character.name.toString();
    strengthController.text = character.strength.toString();
    dexterityController.text = character.dexterity.toString();
    constitutionController.text = character.constitution.toString();
    intelligenceController.text = character.intelligence.toString();
    wisdomController.text = character.wisdom.toString();
    charismaController.text = character.charisma.toString();
    hpController.text = character.hpMax.toString();
    remainingHpController.text = character.hpCurrent.toString();
    caController.text = character.ca.toString();

  }


  void _onSelectCacWeapon(SelectCacWeapon event, Emitter<EditCharacterFormState> emit) {
    emit(FormLoading());
    character.cacWeapon = event.weapon;
    emit(FormLoaded(character, _cacWeapons, _distWeapons));
  }

  void _onSelectDistWeapon(SelectDistWeapon event, Emitter<EditCharacterFormState> emit) {
    emit(FormLoading());
    character.distWeapon = event.weapon;
    emit(FormLoaded(character, _cacWeapons, _distWeapons));
  }

  @override
  Future<void> close() {
    strengthController.dispose();
    dexterityController.dispose();
    constitutionController.dispose();
    intelligenceController.dispose();
    wisdomController.dispose();
    charismaController.dispose();
    hpController.dispose();
    remainingHpController.dispose();
    caController.dispose();

    return super.close();
  }

}
