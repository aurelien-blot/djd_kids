import 'package:djd_kids/model/enums.dart';
import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/service/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/character.dart';
import '../../model/creature.dart';
import 'character_form_event.dart';
import 'character_form_state.dart';

class CharacterFormBloc extends Bloc<CharacterFormEvent, CharacterFormState> {

  final DatabaseService databaseService;
  final CharacterService characterService;

  Character? _character;
  List<Character> _characters = [];
  List<Creature> _creatures = [];

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


  CharacterFormBloc({required this.databaseService, required this.characterService}) : super(FormLoading()) {
    on<InitializeCharacterFormEvent>(_onInitializeCharacterForm);
    on<CreationTypeChangeEvent>(_onCreationTypeChangeEvent);
    on<SelectCharacter>(_onSelectCharacter);
    on<SelectCreature>(_onSelectCreature);
  }

  Future<void> _onInitializeCharacterForm(InitializeCharacterFormEvent event, Emitter<CharacterFormState> emit) async {
    FormLoading();
    _character = characterService.initNewCharacter();
    _characters = await databaseService.getCharacters();
    _creatures = await databaseService.getCreatures();
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.character, _fromCharacter, _fromCreature));
  }

  Future<void> _onCreationTypeChangeEvent(CreationTypeChangeEvent event, Emitter<CharacterFormState> emit) async {
    FormLoading();
    _fromCreature = null;
    _fromCharacter = null;
    emit(FormLoaded(_character!, _characters, _creatures, event.characterCreationType, _fromCharacter, _fromCreature));
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

  void _onSelectCharacter(SelectCharacter event, Emitter<CharacterFormState> emit) {
    FormLoading();
    _fromCharacter = event.character;
    _fromCreature = null;
    _character = event.character;
    _updateControllersWithCharacter(_character!);
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.character, _fromCharacter, _fromCreature));
  }

  void _onSelectCreature(SelectCreature event, Emitter<CharacterFormState> emit) {
    FormLoading();
    _fromCharacter = null;
    _fromCreature = event.creature;
    _character = characterService.initCharacter("", event.creature);
    _updateControllersWithCharacter(_character!);
    emit(FormLoaded(_character!, _characters, _creatures, CharacterCreationType.creature, _fromCharacter, _fromCreature));
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
