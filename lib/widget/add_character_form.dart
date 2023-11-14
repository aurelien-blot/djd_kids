import 'package:djd_kids/model/enums.dart';
import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/widget/buttons/cancel_button.dart';
import 'package:djd_kids/widget/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/character_form/character_form_bloc.dart';
import '../bloc/character_form/character_form_event.dart';
import '../bloc/character_form/character_form_state.dart';
import '../model/character.dart';
import '../model/creature.dart';
import '../service/database_service.dart';
import 'buttons/validation_button.dart';
import 'incorrect_state_screen.dart';

class AddCharacterForm extends StatelessWidget {
  final TeamType teamType;
  final DatabaseService databaseService;
  final CharacterService characterService;
  final _formKey = GlobalKey<FormState>();
  AddCharacterForm({Key? key, required this.teamType, required this.databaseService, required this.characterService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return CharacterFormBloc(databaseService: databaseService , characterService: characterService)
            ..add(InitializeCharacterFormEvent());
        },
        child: BlocConsumer<CharacterFormBloc, CharacterFormState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is FormLoading) {
                return const LoadingDialog();
              } else if (state is FormLoaded) {
                return _buildForm(context, state);
              } else {
                return const IncorrectStateScreen(); // Gérer les autres états
              }
            }
        ),
    );
  }

  Widget _buildForm(BuildContext context, FormLoaded state) {
    Character newCharacter = state.character;
    return AlertDialog(
      title: const Text("Création d'un personnage"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(children: [
                Expanded( child:
                  RadioListTile<CharacterCreationType>(
                    title: const Text('Personnage'),
                    value: CharacterCreationType.character,
                    groupValue: state.characterCreationType,
                    onChanged: (CharacterCreationType? value) {
                      context.read<CharacterFormBloc>().add(CreationTypeChangeEvent(value!));
                    },
                  ),
                ),
                Expanded( child:
                  RadioListTile<CharacterCreationType>(
                    title: const Text('Créature'),
                    value: CharacterCreationType.creature,
                    groupValue: state.characterCreationType,
                    onChanged: (CharacterCreationType? value) {
                      context.read<CharacterFormBloc>().add(CreationTypeChangeEvent(value!));
                    },
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(state.characterCreationType == CharacterCreationType.character)...[
                      DropdownButton<Character>(
                        items: state.characters.map((Character item) {
                          return DropdownMenuItem<Character>(
                            value: item,
                            child: Builder(
                              builder: (BuildContext context) {
                                return Text(item.name);
                              }
                            ),
                          );
                        }).toList(),
                        value: state.fromCharacter,
                        onChanged: (Character? value) {
                          context.read<CharacterFormBloc>().add(SelectCharacter(value!));
                        },
                        dropdownColor: Colors.grey[400],
                        hint: const Text("Choisir un personnage"),
                        ),
                    ]
                    else if(state.characterCreationType == CharacterCreationType.creature)...[
                      DropdownButton<Creature>(
                        items: state.creatures.map((Creature item) {
                          return DropdownMenuItem<Creature>(
                            value: item,
                            child: Builder(
                                builder: (BuildContext context) {
                                  return Text(item.name!);
                                }
                            ),
                          );
                        }).toList(),
                        value: state.fromCreature,
                        onChanged: (Creature? value) {
                          context.read<CharacterFormBloc>().add(SelectCreature(value!));
                        },
                        dropdownColor: Colors.grey[400],
                        hint: const Text("Choisir une créature"),
                      ),
                    ]
                ]
              ),
              if(state.fromCharacter !=null || state.fromCreature!=null)...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child :
                      TextFormField(
                        controller: context.read<CharacterFormBloc>().nameController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        onSaved: (value) => newCharacter.name = value!,
                        validator: (value) {
                          return (value == null || value.isEmpty) ? 'Ce champ est requis.' : null;
                        },
                      ),
                    ),
                  ]
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().strengthController,
                          decoration: const InputDecoration(labelText: 'Force'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.strength = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().dexterityController,
                          decoration: const InputDecoration(labelText: 'Dextérité'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.dexterity = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().constitutionController,
                          decoration: const InputDecoration(labelText: 'Constitution'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.constitution = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().intelligenceController,
                          decoration: const InputDecoration(labelText: 'Intelligence'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.intelligence = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().wisdomController,
                          decoration: const InputDecoration(labelText: 'Sagesse'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.wisdom = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().charismaController,
                          decoration: const InputDecoration(labelText: 'Charisme'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.charisma = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().hpController,
                          decoration: const InputDecoration(labelText: 'CA'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.hpMax = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child :
                        TextFormField(
                          controller: context.read<CharacterFormBloc>().hpController,
                          decoration: const InputDecoration(labelText: 'Pts de Vie'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.hpMax = int.tryParse(value ?? '') ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est requis.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide.';
                            }
                            return null;
                          },
                        ),
                      ),

                    ]
                ),
              ]
            ],
          ),
        ),
      ),
      actions: [
        CancelButton(
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        ValidationButton(
            isEnabled: true,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).pop(newCharacter);
              }
            }
        )
      ],
    );
  }
}