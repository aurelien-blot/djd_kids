import 'package:djd_kids/bloc/fight/fight_state.dart';
import 'package:djd_kids/constants.dart';
import 'package:djd_kids/service/database_service.dart';
import 'package:djd_kids/widget/action_panel.dart';
import 'package:djd_kids/widget/attack_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fight/fight_bloc.dart';
import '../bloc/fight/fight_event.dart';
import '../model/character.dart';
import '../model/enums.dart';
import '../model/fight.dart';
import '../service/ability_service.dart';
import '../service/character_service.dart';
import '../widget/add_character_form.dart';
import '../widget/edit_character_form.dart';
import '../widget/initiative_band.dart';
import '../widget/loading_dialog.dart';

class FightScreen extends StatelessWidget {
  final DatabaseService databaseService;
  final CharacterService characterService;
  final AbilityService abilityService = AbilityService();
  Character? selectedCharacter;
  Character? targetedCharacter;
  bool isActionSelected = false;

  FightScreen({Key? key, required this.databaseService, required this.characterService}) : super(key: key);

  void _showAddCharacterModal(BuildContext context, TeamType teamType) async{
    final FightBloc fightBloc = context.read<FightBloc>();
    final result = await showDialog<Character>(
      context: context,
      builder: (ctx) => AddCharacterForm(teamType: teamType, databaseService: databaseService, characterService: characterService),
    );
    if (result != null) {
      fightBloc.add(AddCharacterEvent(teamType, result));
    }
  }

  void _openAttackDialog(BuildContext context, OpenAttackDialogState state) async {
    AttackType attackType = AttackType.UNKNOW;
    if(state.cacModeEnabled){
      attackType = AttackType.CAC;
    }
    else if(state.distModeEnabled){
      attackType = AttackType.RANGED;
    }
    else if(state.magicModeEnabled){
      attackType = AttackType.MAGIC;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AttackDialog(fightBloc:context.read<FightBloc>(), abilityService: abilityService, attacker: selectedCharacter!, defender: targetedCharacter!, attackType: attackType);
      },
    );
  }

  void _openEditCharacterDialog(BuildContext context, OpenEditCharacterDialogState state) async{
    final FightBloc fightBloc = context.read<FightBloc>();
    final result = await showDialog<Character>(
      context: context,
      builder: (ctx) => EditCharacterForm(databaseService: databaseService , character: state.selectedCharacter),
    );
    if (result != null) {
      fightBloc.add(EditCharacterEvent(result));
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
            child: Text(' Ajouter un ${teamType == TeamType.allies?'allié':'ennemi'}'),
          ),
        ],
      ),
    );
  }

  Color _selectCharacterColor(Character character){
    if(character.isDead){
      return Colors.grey;
    }
    else if(character.hpCurrent >= character.hpMax){
      return Colors.green;
    }
    else if(character.hpCurrent > character.hpMax *0.75){
      return Colors.lightGreen;
    }
    else if(character.hpCurrent > character.hpMax *0.5){
      return Colors.yellow;
    }
    else if(character.hpCurrent > character.hpMax *0.25){
      return Colors.orange;
    }
    else{
      return Colors.red;
    }
  }

  Widget _characterCard(BuildContext context, Character character) {
    bool isCharacterSelected = selectedCharacter == character;
    bool isTargetSelected = targetedCharacter == character;
    String title = character.name;
    if (character.creatureName!=null) {
      title += ' (${character.creatureName})';
    }

    String weaponLabel = '';
    if (character.cacWeapon!=null) {
      weaponLabel += character.cacWeapon!.name!;
    }
    if (character.distWeapon!=null && character.cacWeapon!=null) {
      weaponLabel += ' / ';
    }
    if (character.distWeapon!=null) {
      weaponLabel += character.distWeapon!.name!;
    }

    Color characterColor = _selectCharacterColor(character);

    Color? cardColor;
    if(isCharacterSelected){
      cardColor = Colors.blue[100];
    }
    else if(isTargetSelected){
      cardColor = Colors.red[100];
    }
    return Card(
      color: cardColor,
      child: ListTile(
        onTap: () {
          if(character.isDead){
            return;
          }
          if(isActionSelected && selectedCharacter!=null && selectedCharacter!=character){
            context.read<FightBloc>().add(SelectTargetedCharacterEvent(character));
          }
          else{
            context.read<FightBloc>().add(SelectCharacterEvent(character));
          }
        },
        leading: Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/characters/anonym.jpg'),
            ),
            if (character.isDead) // Affiche une croix rouge si le personnage est mort
              const Icon(Icons.cancel, color: Colors.red, size: 30),
          ],
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children :[
              Text(title),
              Text('PV : ${character.hpCurrent}/${character.hpMax}', style:
                TextStyle(color: characterColor, fontWeight: FontWeight.bold)
                )
            ]
        ),
        subtitle:
            Column(
              children: [
                Padding(
                padding: const EdgeInsets.all(8.0),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children :[
                        Text('Init : ${character.initiative}'),
                        Text('CA : ${character.ca}'),
                        Text(weaponLabel)
                      ]
                  ),
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
          return FightBloc(databaseService, abilityService, characterService)..add(InitializeFightEvent());
        },
        child: BlocConsumer<FightBloc, FightState>(
            listener: (context, state) {
              if(state is OpenAttackDialogState){
                _openAttackDialog(context, state);
              }
              else if(state is OpenEditCharacterDialogState){
                _openEditCharacterDialog(context, state);
              }
              else if (state is FightLoadedWithSelectedCharacter) {
                selectedCharacter = state.selectedCharacter;
                targetedCharacter = state.targetedCharacter;
                isActionSelected = state.isActionSelected;
              }
              else if (state is FightLoaded) {
                selectedCharacter = null;
                targetedCharacter = null;
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
                print(state.fight.id);
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
                                    if(state is  FightLoadedWithSelectedCharacter)...[
                                      Expanded(
                                        flex: 1,
                                        child: ActionPanel(selectedCharacter: state.selectedCharacter,
                                            cacModeEnabled : state.cacModeEnabled, distModeEnabled : state.distModeEnabled,
                                            magicModeEnabled : state.magicModeEnabled, diceRollButtonEnabled : state.targetedCharacter!=null && state.isActionSelected),
                                      ),
                                    ]
                                    else ...[
                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox.shrink(),
                                      ),
                                    ],
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
