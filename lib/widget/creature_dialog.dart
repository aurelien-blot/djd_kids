import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/creature.dart';

class CreatureDialog extends StatefulWidget {
  final Creature? creature;

  const CreatureDialog({Key? key, this.creature}) : super(key: key);

  @override
    _CreatureDialogState createState() => _CreatureDialogState();
}

class _CreatureDialogState extends State<CreatureDialog> {
  final _formKey = GlobalKey<FormState>();
  late Creature _currentCreature;

  @override
  void initState() {
    super.initState();
    // Initialiser _currentCreature avec la créature passée ou créer une nouvelle instance
    _currentCreature = widget.creature ?? Creature(wisdom: 0, strength: 0, dexterity: 0, constitution: 0, intelligence: 0, charisma: 0, diceHpNumber: 0, diceHpValue: 0, diceHpBonus: 0, ca: 0, cacAbility: CacAbility.FOR);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(_currentCreature);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_currentCreature.id == null ? 'Ajouter une créature' : 'Modifier la créature'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _currentCreature.name,
                decoration: const InputDecoration(labelText: 'Nom'),
                onSaved: (value) => _currentCreature.name = value,
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
                      initialValue: _currentCreature.strength.toString(),
                      decoration: const InputDecoration(labelText: 'Force'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentCreature.strength = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentCreature.dexterity.toString(),
                    decoration: const InputDecoration(labelText: 'Dextérité'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCreature.dexterity = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentCreature.constitution.toString(),
                    decoration: const InputDecoration(labelText: 'Constitution'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCreature.constitution = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentCreature.intelligence.toString(),
                    decoration: const InputDecoration(labelText: 'Intelligence'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCreature.intelligence = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentCreature.wisdom.toString(),
                    decoration: const InputDecoration(labelText: 'Sagesse'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCreature.wisdom = int.tryParse(value ?? '') ?? 0,
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
                  initialValue: _currentCreature.charisma.toString(),
                  decoration: const InputDecoration(labelText: 'Charisme'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _currentCreature.charisma = int.tryParse(value ?? '') ?? 0,
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
                      initialValue: _currentCreature.ca.toString(),
                      decoration: const InputDecoration(labelText: 'CA'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentCreature.ca = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentCreature.diceHpNumber.toString(),
                    decoration: const InputDecoration(labelText: 'Nbre Dés de vie'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentCreature.diceHpNumber = int.tryParse(value ?? '') ?? 0,
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
                      initialValue: _currentCreature.diceHpValue.toString(),
                      decoration: const InputDecoration(labelText: 'Faces dés de vie'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentCreature.diceHpValue = int.tryParse(value ?? '') ?? 0,
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
                  Expanded(
                    child :
                    TextFormField(
                      initialValue: _currentCreature.diceHpBonus.toString(),
                      decoration: const InputDecoration(labelText: 'Pts vie additionnels'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentCreature.diceHpBonus = int.tryParse(value ?? '') ?? 0,
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
