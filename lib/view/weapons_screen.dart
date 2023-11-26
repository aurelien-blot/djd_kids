import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weapon/weapons_bloc.dart';
import '../bloc/weapon/weapons_event.dart';
import '../bloc/weapon/weapons_state.dart';
import '../model/weapon.dart';
import '../widget/weapon_dialog.dart';
import '../widget/loading_dialog.dart';

class WeaponsScreen extends StatelessWidget {
  const WeaponsScreen({super.key});

  void _addOrEditWeapon(BuildContext context, Weapon? weapon) async {
    // Capturez le Bloc une fois avant de lancer des opérations asynchrones
    final weaponsBloc = context.read<WeaponsBloc>();

    // Affichez la boîte de dialogue
    final result = await showDialog<Weapon>(
      context: context,
      builder: (ctx) => WeaponDialog(weapon: weapon),
    );

    // Après la boîte de dialogue, vérifiez si le résultat n'est pas null
    // et si le widget est toujours dans l'arbre des widgets.
    if (result != null) {
      if (weapon == null) {
        weaponsBloc.add(AddWeaponEvent(result));
      } else {
        weaponsBloc.add(EditWeaponEvent(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<WeaponsBloc>().add(LoadWeapons());

    return BlocBuilder<WeaponsBloc, WeaponsState>(
      builder: (context, state) {
        if (state is WeaponsLoading) {
          return const LoadingDialog();
        }
        if (state is WeaponsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _addOrEditWeapon(context, null);
                    },
                    child: const Icon(Icons.add),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10))
                ]
              ),
              const Padding(padding: EdgeInsets.only(bottom : 10)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Arme')),
                      DataColumn(label: Text('Caractéristiques')),
                      DataColumn(label: Text('Type')),
                    ],
                    rows: state.weapons.map((weapon) => DataRow(
                      cells: [
                        DataCell(Text(weapon.name??''), onTap: () => _addOrEditWeapon(context, weapon)),
                        DataCell(Text(weapon.degatsDetails.toString()), onTap: () => _addOrEditWeapon(context, weapon)),
                        DataCell(Text(weapon.weaponType.name), onTap: () => _addOrEditWeapon(context, weapon)),
                      ],
                    )).toList(),
                  ),
                ),
              )
            ],
          );
        }
        if (state is WeaponsError) {
          return const Center(child: Text('Erreur de chargement des créatures'));
        }
        return const LoadingDialog();
      },
    );
  }
}
