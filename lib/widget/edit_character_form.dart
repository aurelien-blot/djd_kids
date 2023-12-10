import 'package:djd_kids/widget/buttons/cancel_button.dart';
import 'package:djd_kids/widget/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/character_form/edit_character_form_bloc.dart';
import '../bloc/character_form/edit_character_form_event.dart';
import '../bloc/character_form/edit_character_form_state.dart';
import '../constants.dart';
import '../model/character.dart';
import '../model/weapon.dart';
import '../service/database_service.dart';
import 'buttons/validation_button.dart';
import 'incorrect_state_screen.dart';

class EditCharacterForm extends StatelessWidget {
  final Character character;
  final DatabaseService databaseService;
  final _formKey = GlobalKey<FormState>();
  EditCharacterForm({Key? key, required this.databaseService, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return EditCharacterFormBloc(databaseService: databaseService , character: character)
            ..add(InitializeEditCharacterFormEvent());
        },
        child: BlocConsumer<EditCharacterFormBloc, EditCharacterFormState>(
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
    Character character = state.character;
    return AlertDialog(
      title: const Text("Modifier le personnage"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child :
                    TextFormField(
                      controller: context.read<EditCharacterFormBloc>().nameController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                      onSaved: (value) => character.name = value!,
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
                      selected: <CacAbility>{character.cacAbility},
                      onSelectionChanged: (Set<CacAbility> newSelection) {
                        context.read<EditCharacterFormBloc>().add(SelectCacAbility(newSelection.first));
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
                        controller: context.read<EditCharacterFormBloc>().strengthController,
                        decoration: const InputDecoration(labelText: 'Force'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.strength = int.tryParse(value ?? '') ?? 0,
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
                        controller: context.read<EditCharacterFormBloc>().dexterityController,
                        decoration: const InputDecoration(labelText: 'Dextérité'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.dexterity = int.tryParse(value ?? '') ?? 0,
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
                        controller: context.read<EditCharacterFormBloc>().constitutionController,
                        decoration: const InputDecoration(labelText: 'Constitution'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.constitution = int.tryParse(value ?? '') ?? 0,
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
                        controller: context.read<EditCharacterFormBloc>().intelligenceController,
                        decoration: const InputDecoration(labelText: 'Intelligence'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.intelligence = int.tryParse(value ?? '') ?? 0,
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
                        controller: context.read<EditCharacterFormBloc>().wisdomController,
                        decoration: const InputDecoration(labelText: 'Sagesse'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.wisdom = int.tryParse(value ?? '') ?? 0,
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
                        controller: context.read<EditCharacterFormBloc>().charismaController,
                        decoration: const InputDecoration(labelText: 'Charisme'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.charisma = int.tryParse(value ?? '') ?? 0,
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
                        controller: context.read<EditCharacterFormBloc>().caController,
                        decoration: const InputDecoration(labelText: 'CA'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => character.ca = int.tryParse(value ?? '') ?? 0,
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
              const Padding(padding: EdgeInsets.only(bottom: 14)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child :
                    TextFormField(
                      controller: context.read<EditCharacterFormBloc>().remainingHpController,
                      decoration: const InputDecoration(labelText: 'Pts de Vie Restant'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => character.hpCurrent = int.tryParse(value ?? '') ?? 0,
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
                      controller: context.read<EditCharacterFormBloc>().hpController,
                      decoration: const InputDecoration(labelText: 'Pts de Vie'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => character.hpMax = int.tryParse(value ?? '') ?? 0,
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
                        value: character.cacWeapon,
                        onChanged: (Weapon? value) {
                          context.read<EditCharacterFormBloc>().add(SelectCacWeapon(value));
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
                          context.read<EditCharacterFormBloc>().add(SelectCacWeapon(null));
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
                        value: character.distWeapon,
                        onChanged: (Weapon? value) {
                          context.read<EditCharacterFormBloc>().add(SelectDistWeapon(value));
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
                          context.read<EditCharacterFormBloc>().add(SelectDistWeapon(null));
                        },
                      ),
                    )
                  ]
              ),
            ]
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
                Navigator.of(context).pop(character);
              }
            }
        )
      ],
    );
  }
}