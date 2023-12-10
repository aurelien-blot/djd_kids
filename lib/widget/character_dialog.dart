import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/character.dart';

class CharacterDialog extends StatefulWidget {
  final Character? character;

  const CharacterDialog({Key? key, this.character}) : super(key: key);

  @override
    _CharacterDialogState createState() => _CharacterDialogState();
}

class _CharacterDialogState extends State<CharacterDialog> {
  final _formKey = GlobalKey<FormState>();
  late Character _currentCharacter;

  @override
  void initState() {
    super.initState();
    // Initialiser _currentCharacter avec la créature passée ou créer une nouvelle instance
    _currentCharacter = widget.character ?? Character(wisdom: 0, strength: 0, dexterity: 0, constitution: 0, intelligence: 0, charisma: 0, ca: 0, cacAbility: CacAbility.FOR, name: '', hpMax: 0, hpCurrent: 0);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(_currentCharacter);
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_currentCharacter.id == null ? 'Ajouter une créature' : 'Modifier la créature'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _currentCharacter.name,
                decoration: const InputDecoration(labelText: 'Nom'),
                onSaved: (value) => _currentCharacter.name = value!,
                validator: (value) {
                  return (value == null || value.isEmpty) ? 'Ce champ est requis.' : null;
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child :
                      TextFormField(
                      initialValue: _currentCharacter.strength.toString(),
                      decoration: const InputDecoration(labelText: 'Force'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentCharacter.strength = int.tryParse(value ?? '') ?? 0,
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
                  Expanded(
                    child :
                      TextFormField(
                    initialValue: _currentCharacter.dexterity.toString(),
                    decoration: const InputDecoration(labelText: 'Dextérité'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCharacter.dexterity = int.tryParse(value ?? '') ?? 0,
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
                  Expanded(
                    child :
                      TextFormField(
                    initialValue: _currentCharacter.constitution.toString(),
                    decoration: const InputDecoration(labelText: 'Constitution'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCharacter.constitution = int.tryParse(value ?? '') ?? 0,
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
                  Expanded(
                    child :
                      TextFormField(
                    initialValue: _currentCharacter.intelligence.toString(),
                    decoration: const InputDecoration(labelText: 'Intelligence'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCharacter.intelligence = int.tryParse(value ?? '') ?? 0,
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
                  Expanded(
                    child :
                      TextFormField(
                    initialValue: _currentCharacter.wisdom.toString(),
                    decoration: const InputDecoration(labelText: 'Sagesse'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCharacter.wisdom = int.tryParse(value ?? '') ?? 0,
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
                  Expanded(
                    child :
                      TextFormField(
                  initialValue: _currentCharacter.charisma.toString(),
                  decoration: const InputDecoration(labelText: 'Charisme'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _currentCharacter.charisma = int.tryParse(value ?? '') ?? 0,
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
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child :
                      TextFormField(
                      initialValue: _currentCharacter.ca.toString(),
                      decoration: const InputDecoration(labelText: 'CA'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentCharacter.ca = int.tryParse(value ?? '') ?? 0,
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
                      initialValue: _currentCharacter.hpMax.toString(),
                      decoration: const InputDecoration(labelText: 'Pts de Vie'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                          _currentCharacter.hpMax = int.tryParse(value ?? '') ?? 0;
                          _currentCharacter.hpCurrent = _currentCharacter.hpMax;
                      },
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
                      selected: <CacAbility>{_currentCharacter.cacAbility},
                      onSelectionChanged: (Set<CacAbility> newSelection) {
                        setState(() {
                          _currentCharacter.cacAbility = newSelection.first;
                        });

                      },
                    ),
                  )

                ]
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
