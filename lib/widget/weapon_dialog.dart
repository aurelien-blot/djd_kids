import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/weapon.dart';

class WeaponDialog extends StatefulWidget {
  final Weapon? weapon;

  const WeaponDialog({Key? key, this.weapon}) : super(key: key);

  @override
    _WeaponDialogState createState() => _WeaponDialogState();
}

class _WeaponDialogState extends State<WeaponDialog> {
  final _formKey = GlobalKey<FormState>();
  late Weapon _currentWeapon;

  @override
  void initState() {
    super.initState();
    // Initialiser _currentWeapon avec la créature passée ou créer une nouvelle instance
    _currentWeapon = widget.weapon ?? Weapon(name: '', diceDegatsNumber: 0, diceDegatsValue: 0, diceDegatsBonus: 0, weaponType: WeaponType.UNKNOW);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(_currentWeapon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_currentWeapon.id == null ? 'Ajouter une créature' : 'Modifier la créature'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _currentWeapon.name,
                decoration: const InputDecoration(labelText: 'Nom'),
                onSaved: (value) => _currentWeapon.name = value,
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
                      initialValue: _currentWeapon.diceDegatsNumber.toString(),
                      decoration: const InputDecoration(labelText: 'Nombre de dés'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _currentWeapon.diceDegatsNumber = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentWeapon.diceDegatsValue.toString(),
                    decoration: const InputDecoration(labelText: 'Valeur des dés'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentWeapon.diceDegatsValue = int.tryParse(value ?? '') ?? 0,
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
                    initialValue: _currentWeapon.diceDegatsBonus.toString(),
                    decoration: const InputDecoration(labelText: 'Bonus'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _currentWeapon.diceDegatsBonus = int.tryParse(value ?? '') ?? 0,
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
              Row(children: [
                Expanded(child :
                DropdownButton<WeaponType>(
                  items: WeaponType.values.map((WeaponType item) {
                    return DropdownMenuItem<WeaponType>(
                      value: item,
                      child: Builder(
                          builder: (BuildContext context) {
                            return Text(item.name);
                          }
                      ),
                    );
                  }).toList(),
                  value: _currentWeapon.weaponType,
                  onChanged: (WeaponType? value) {
                    setState(() {
                      _currentWeapon.weaponType = value!;
                    });
                  },
                  dropdownColor: Colors.grey[400],
                  hint: const Text("Choisir un type"),
                ),
                ),
              ],)
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
