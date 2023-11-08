import 'package:djd_kids/bloc/fight/fight_state.dart';
import 'package:djd_kids/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fight/fight_bloc.dart';
import '../bloc/fight/fight_event.dart';
import '../model/character.dart';
import '../model/enums.dart';
import '../model/fight.dart';
import '../widget/character_dialog.dart';
import '../widget/loading_dialog.dart';

class FightScreen extends StatelessWidget {
  final DatabaseService databaseService;

  const FightScreen({Key? key, required this.databaseService}) : super(key: key);

  void _showAddCharacterModal(BuildContext context, OpenAddCharacterDialog state) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddCharacterForm( teamType: state.teamType);
      },
    );
  }

  Expanded buildTeamZone(BuildContext context, TeamType teamType, List<Character> team) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: team.length,
              itemBuilder: (context, index) {
                return Text (team[index].name);
                //return CharacterBanner(hero: heroes[index]);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FightBloc>().add(OpenAddCharacterDialogEvent(teamType));
            },
            child: Text('Ajouter un ${teamType == TeamType.allies?'allié':'ennemi'}'),
          ),
        ],
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
              if(state is OpenAddCharacterDialog){
                _showAddCharacterModal(context, state);
              }
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
                          Row(
                            children: [
                              buildTeamZone(context, TeamType.allies, state.fight.allies),
                              buildTeamZone(context, TeamType.enemies, state.fight.enemies),
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
