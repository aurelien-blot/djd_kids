import 'package:djd_kids/bloc/fight/fight_state.dart';
import 'package:djd_kids/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fight/fight_bloc.dart';
import '../bloc/fight/fight_event.dart';
import '../model/character.dart';
import '../model/enums.dart';
import '../model/fight.dart';
import '../service/character_service.dart';
import '../widget/add_character_form.dart';
import '../widget/initiative_band.dart';
import '../widget/loading_dialog.dart';

class FightScreen extends StatelessWidget {
  final DatabaseService databaseService;
  final CharacterService _characterService = CharacterService();

  FightScreen({Key? key, required this.databaseService}) : super(key: key);

  void _showAddCharacterModal(BuildContext context, TeamType teamType) async{
    final FightBloc fightBloc = context.read<FightBloc>();
    final result = await showDialog<Character>(
      context: context,
      builder: (ctx) => AddCharacterForm(teamType: teamType, databaseService: databaseService, characterService: _characterService),
    );
    if (result != null) {
      fightBloc.add(AddCharacterEvent(teamType, result));
    }
  }

  Expanded buildTeamZone(BuildContext context, TeamType teamType, List<Character> team) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: team.length,
              itemBuilder: (context, index) {
                return _characterCard(context, team[index]);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddCharacterModal(context, teamType);
            },
            child: Text('Ajouter un ${teamType == TeamType.allies?'allié':'ennemi'}'),
          ),
        ],
      ),
    );
  }

  Widget _characterCard(BuildContext context, Character character) {
    String title = character.name;
    if (character.creatureName!=null) {
      title += ' (${character.creatureName})';
    }
    return Card(

      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/characters/anonym.jpg'),
        ),
        title: Text(title),
        subtitle:
            Column(
              children: [
                /*Text('PV: ${character.currentHp}/${character.maxHp}'),
                Text('CA: ${character.ca}'),*/
                Padding(
                padding: const EdgeInsets.all(8.0),
                  child:Text('PV: ${character.hpCurrent}/${character.hpMax}')
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Table(
                    children: [
                      const TableRow(
                        children: [
                          Text('FOR', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('DEX', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('CON', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('INT', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('SAG', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('CHA', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('${character.strength}'),
                          Text('${character.dexterity}'),
                          Text('${character.constitution}'),
                          Text('${character.intelligence}'),
                          Text('${character.wisdom}'),
                          Text('${character.charisma}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return FightBloc(databaseService)..add(InitializeFightEvent());
        },
        child: BlocConsumer<FightBloc, FightState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              final fightBloc = context.read<FightBloc>();
              if (state is FightLoading) {
                return const LoadingDialog();
              }
              else if (state is NoFightState) {
                Fight newFight = Fight(allies: [], enemies: [], name: '');
                final formKey = GlobalKey<FormState>();
                return Scaffold(
                  body: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: SizedBox(
                                width: 200, // Définissez la largeur que vous souhaitez
                                child: TextFormField(
                                  initialValue: '',
                                  decoration: const InputDecoration(labelText: 'Nom du combat'),
                                  onSaved: (value) => newFight.name = value!,
                                  validator: (value) {
                                    return (value == null || value.isEmpty) ? 'Ce champ est requis.' : null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    fightBloc.add(CreateFightEvent(newFight));
                                  }
                                },
                                child: const Text('Commencer'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              else if (state is FightLoaded) {
                return Scaffold(
                    body:
                      Padding(padding: const EdgeInsets.all(10),
                        child:
                        Column(
                            children: [
                              InitiativeBand(charactersByInitiative: state.fight.orderedByInitiative),
                              Expanded(
                                child: Row(
                                  children: [
                                    buildTeamZone(context, TeamType.allies, state.fight.allies),
                                    const Expanded(
                                      flex: 1,
                                      child: SizedBox.shrink(),
                                    ),
                                    buildTeamZone(context, TeamType.enemies, state.fight.enemies),
                                  ]
                                ),
                              )
                            ]
                        )
                      )
                );
              } else {
                return const Center(child: Text('Erreur de chargement du combat'));
              }
            }));
  }
}
