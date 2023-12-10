import 'package:djd_kids/model/enums.dart';
import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/widget/buttons/cancel_button.dart';
import 'package:djd_kids/widget/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/character_form/add_character_form_bloc.dart';
import '../bloc/character_form/add_character_form_event.dart';
import '../bloc/character_form/add_character_form_state.dart';
import '../constants.dart';
import '../model/character.dart';
import '../model/creature.dart';
import '../model/weapon.dart';
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
          return AddCharacterFormBloc(databaseService: databaseService , characterService: characterService)
            ..add(InitializeAddCharacterFormEvent());
        },
        child: BlocConsumer<AddCharacterFormBloc, AddCharacterFormState>(
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
                      context.read<AddCharacterFormBloc>().add(CreationTypeChangeEvent(value!));
                    },
                  ),
                ),
                Expanded( child:
                  RadioListTile<CharacterCreationType>(
                    title: const Text('Créature'),
                    value: CharacterCreationType.creature,
                    groupValue: state.characterCreationType,
                    onChanged: (CharacterCreationType? value) {
                      context.read<AddCharacterFormBloc>().add(CreationTypeChangeEvent(value!));
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
                          context.read<AddCharacterFormBloc>().add(SelectCharacter(value!));
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
                          context.read<AddCharacterFormBloc>().add(SelectCreature(value!));
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
                        controller: context.read<AddCharacterFormBloc>().nameController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        onSaved: (value) => newCharacter.name = value!,
                        validator: (value) {
                          return (value == null || value.isEmpty) ? 'Ce champ est requis.' : null;
                        },
                      ),
                    ),
                    Expanded(child:
                    SegmentedButton<CacAbility>(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.blue;
                            }
                            return Colors.grey;
                          },
                        ),
                      ),
                      segments: const <ButtonSegment<CacAbility>>[
                        ButtonSegment<CacAbility>(value: CacAbility.FOR, label: Text('FOR')),
                        ButtonSegment<CacAbility>(value: CacAbility.DEX, label: Text('DEX')),
                      ],
                      selected: <CacAbility>{newCharacter.cacAbility},
                      onSelectionChanged: (Set<CacAbility> newSelection) {
                        context.read<AddCharacterFormBloc>().add(SelectCacAbility(newSelection.first));
                      },
                    ),
                    ),
                  ]
                ),
                const Padding(padding: EdgeInsets.only(bottom: 14)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child :
                        TextFormField(
                          controller: context.read<AddCharacterFormBloc>().strengthController,
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
                          controller: context.read<AddCharacterFormBloc>().dexterityController,
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
                          controller: context.read<AddCharacterFormBloc>().constitutionController,
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
                          controller: context.read<AddCharacterFormBloc>().intelligenceController,
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
                          controller: context.read<AddCharacterFormBloc>().wisdomController,
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
                          controller: context.read<AddCharacterFormBloc>().charismaController,
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
                          controller: context.read<AddCharacterFormBloc>().caController,
                          decoration: const InputDecoration(labelText: 'CA'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => newCharacter.ca = int.tryParse(value ?? '') ?? 0,
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
                          controller: context.read<AddCharacterFormBloc>().hpController,
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
                      const SizedBox(width: 10),


                    ]
                ),
                const Padding(padding: EdgeInsets.only(bottom: 14)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child :
                        DropdownButton<Weapon?>(
                          items: state.cacWeapons.map((Weapon item) {
                            return DropdownMenuItem<Weapon>(
                              value: item,
                              child: Builder(
                                  builder: (BuildContext context) {
                                    return Text(item.weaponFullLabel?? '');
                                  }
                              ),
                            );
                          }).toList(),
                          value: newCharacter.cacWeapon,
                          onChanged: (Weapon? value) {
                            context.read<AddCharacterFormBloc>().add(SelectCacWeapon(value));
                          },
                          dropdownColor: Colors.grey[400],
                          hint: const Text("Choisir une arme de corps à corps"),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.read<AddCharacterFormBloc>().add(SelectCacWeapon(null));
                          },
                        ),
                      )
                    ]
                ),
                const Padding(padding: EdgeInsets.only(bottom: 14)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child :
                        DropdownButton<Weapon?>(
                          items: state.distWeapons.map((Weapon item) {
                            return DropdownMenuItem<Weapon>(
                              value: item,
                              child: Builder(
                                  builder: (BuildContext context) {
                                    return Text(item.weaponFullLabel?? '');
                                  }
                              ),
                            );
                          }).toList(),
                          value: newCharacter.distWeapon,
                          onChanged: (Weapon? value) {
                            context.read<AddCharacterFormBloc>().add(SelectDistWeapon(value));
                          },
                          dropdownColor: Colors.grey[400],
                          hint: const Text("Choisir une arme de distance"),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.read<AddCharacterFormBloc>().add(SelectDistWeapon(null));
                          },
                        ),
                      )
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