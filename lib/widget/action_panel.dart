import 'package:djd_kids/bloc/fight/fight_bloc.dart';
import 'package:djd_kids/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/fight/fight_event.dart';
import '../model/character.dart';

class ActionPanel extends StatelessWidget {
  final Character selectedCharacter;
  final bool cacModeEnabled;
  final bool distModeEnabled;
  final bool magicModeEnabled;
  final bool diceRollButtonEnabled;

  bool get isActionSelected => cacModeEnabled || distModeEnabled || magicModeEnabled;

  const ActionPanel({
    Key? key,
    required this.selectedCharacter, required this.cacModeEnabled, required this.distModeEnabled, required this.magicModeEnabled, required this.diceRollButtonEnabled
  }) : super(key: key);

  void _onMeleeAttack(BuildContext context) {
    context.read<FightBloc>().add(SelectCacAttackEvent());
  }

  void _onRangedAttack(BuildContext context) {
    context.read<FightBloc>().add(SelectDistAttackEvent());
  }

  void _onMagicAttack(BuildContext context) {
    context.read<FightBloc>().add(SelectMagicAttackEvent());
  }

  void _onEditCharacter(BuildContext context) {
    context.read<FightBloc>().add(OpenEditCharacterDialogEvent());
  }
  void _onDiceRoll(BuildContext context) {
    context.read<FightBloc>().add(OpenAttackDialogEvent());
  }

  @override
  Widget build(BuildContext context) {
    Color distColor = Colors.grey;
    if(selectedCharacter.distWeapon!=null){
      distColor = !isActionSelected?Colors.blue:distModeEnabled?Colors.red:Colors.grey;
    }
    return Padding(padding: const EdgeInsets.fromLTRB(0,20,0,20),
      child : Align(
        alignment: Alignment.topCenter,
        child:
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(child: Text(selectedCharacter.name, style: const TextStyle(fontSize: 20))),
              if(diceRollButtonEnabled)...[
                Padding(padding: const EdgeInsets.fromLTRB(0,30,0,0),
                  child:  Center(child:
                    FloatingActionButton(
                      backgroundColor: Colors.orange,
                      onPressed: () {
                        _onDiceRoll(context);
                      },
                      child: const Icon(FontAwesomeIcons.diceD20),
                    ),
                  ),
                )
              ]
              else ...[
                const Padding(padding: EdgeInsets.fromLTRB(0,86,0,0),
                  child: SizedBox.shrink(),
                )
              ],
              Padding(padding: const EdgeInsets.fromLTRB(0,30,0,30),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      backgroundColor: !isActionSelected?Colors.blue:cacModeEnabled?Colors.red:Colors.grey,
                      onPressed: () {
                        _onMeleeAttack(context);
                      },
                      child: const SvgIcon(
                        path: 'assets/icons/sword.svg',
                      )
                    ),
                    FloatingActionButton(
                      backgroundColor: distColor,
                      onPressed: () {
                        if(selectedCharacter.distWeapon!=null){
                          _onRangedAttack(context);
                        }
                      },
                      child: const SvgIcon(
                        path: 'assets/icons/bow.svg',
                      )
                    ),
                     FloatingActionButton(
                      backgroundColor: Colors.grey,//!isActionSelected?Colors.blue:magicModeEnabled?Colors.red:Colors.grey,
                      onPressed: () {
                        //_onMagicAttack(context);
                      },
                      child: const SvgIcon(
                        path: 'assets/icons/spell.svg',
                      )
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      _onEditCharacter(context);
                    },
                    child: const Icon(FontAwesomeIcons.penToSquare),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
