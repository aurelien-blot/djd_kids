import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/creature/creatures_bloc.dart';
import '../bloc/creature/creatures_event.dart';
import '../bloc/creature/creatures_state.dart';
import '../model/creature.dart';
import '../widget/creature_dialog.dart';
import '../widget/loading_dialog.dart';

class CreaturesScreen extends StatelessWidget {
  const CreaturesScreen({super.key});

  void _addOrEditCreature(BuildContext context, Creature? creature) async {
    // Capturez le Bloc une fois avant de lancer des opérations asynchrones
    final creaturesBloc = context.read<CreaturesBloc>();

    // Affichez la boîte de dialogue
    final result = await showDialog<Creature>(
      context: context,
      builder: (ctx) => CreatureDialog(creature: creature),
    );

    // Après la boîte de dialogue, vérifiez si le résultat n'est pas null
    // et si le widget est toujours dans l'arbre des widgets.
    if (result != null) {
      if (creature == null) {
        creaturesBloc.add(AddCreatureEvent(result));
      } else {
        creaturesBloc.add(EditCreatureEvent(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<CreaturesBloc>().add(LoadCreatures());

    return BlocBuilder<CreaturesBloc, CreaturesState>(
      builder: (context, state) {
        if (state is CreaturesLoading) {
          return const LoadingDialog();
        }
        if (state is CreaturesLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _addOrEditCreature(context, null);
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
                      DataColumn(label: Text('Créature')),
                      DataColumn(label: Text('Force')),
                      DataColumn(label: Text('Dextérité')),
                      DataColumn(label: Text('Constitution')),
                      DataColumn(label: Text('Intelligence')),
                      DataColumn(label: Text('Sagesse')),
                      DataColumn(label: Text('Charisme')),
                      DataColumn(label: Text('CAC Carac')),
                      DataColumn(label: Text('CA')),
                      DataColumn(label: Text('Vie')),
                    ],
                    rows: state.creatures.map((creature) => DataRow(
                      cells: [
                        DataCell(Text(creature.name??''), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.strength.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.dexterity.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.constitution.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.intelligence.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.wisdom.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.charisma.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.ca.toString()), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.cacAbility.name), onTap: () => _addOrEditCreature(context, creature)),
                        DataCell(Text(creature.hpDetails), onTap: () => _addOrEditCreature(context, creature)),
                      ],
                    )).toList(),
                  ),
                ),
              )
            ],
          );
        }
        if (state is CreaturesError) {
          return const Center(child: Text('Erreur de chargement des créatures'));
        }
        return const LoadingDialog();
      },
    );
  }
}
