import 'package:djd_kids/bloc/attack_dialog/attack_dialog_event.dart';
import 'package:djd_kids/bloc/attack_dialog/attack_dialog_state.dart';
import 'package:djd_kids/bloc/fight/fight_bloc.dart';
import 'package:djd_kids/constants.dart';
import 'package:djd_kids/model/character.dart';
import 'package:djd_kids/service/ability_service.dart';
import 'package:djd_kids/widget/incorrect_state_screen.dart';
import 'package:djd_kids/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/attack_dialog/attack_dialog_bloc.dart';
import '../bloc/fight/fight_event.dart';
import '../model/weapon.dart';
import 'buttons/cancel_button.dart';
import 'buttons/validation_button.dart';
import 'loading_dialog.dart';

class AttackDialog extends StatelessWidget {
  final FightBloc fightBloc;
  final AttackType attackType;
  final Character defender;
  final Character attacker;
  final AbilityService abilityService;

  AttackDialog({Key? key, required this.fightBloc,required this.defender, required this.attacker, required this.abilityService, required this.attackType}) : super(key: key);

  final TextEditingController _degatsDiceController = TextEditingController();

  @override
  dispose() {
    _degatsDiceController.dispose();
  }

  List<Widget> _buildModifierContent(BuildContext context, AttackDialogLoaded state) {
    return [
      const Text("Modificateur MJ: "),
      const SizedBox(width: 8),
      DropdownButton<int>(
        value: state.modifier,
        items: state.modifierList.map((int result) {
          return DropdownMenuItem<int>(
            value: result,
            child: Text("$result"),
          );
        }).toList(),
        onChanged: (int? value) {
          context.read<AttackDialogBloc>().add(UpdateMJModifierEvent(value!));
        },
      ),
    ];
  }

  List<Widget> _buildAbilitySegmentedContent(BuildContext context, AttackDialogLoaded state) {
    return [
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
        selected: <CacAbility>{state.cacAbility},
        onSelectionChanged: (Set<CacAbility> newSelection) {
          context.read<AttackDialogBloc>().add(UpdateCacAbilityEvent(newSelection.first));
        },
      ),
    ];
  }

  List<Widget> _buildDiceContent(BuildContext context, AttackDialogLoaded state) {
    return [
      const Text("Dé : "),
      const SizedBox(width: 8),
      SizedBox(
        width: 50,
        child: TextFormField(
            initialValue: '',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              context.read<AttackDialogBloc>().add(UpdateTouchDiceResultEvent(value));
            }),
      ),
    ];
  }

  List<Widget> _buildModifierInfoContent(BuildContext context, AttackDialogLoaded state) {
    return [
      Text("Modificateur ${state.cacAbility.name} : "),
      const SizedBox(width: 8),
      Text(state.abilityModifier.toString()),
    ];
  }

  List<Widget> _buildTargetContent(BuildContext context, AttackDialogLoaded state) {
    return [
      const Text("CA de la cible : "),
      const SizedBox(width: 8),
      Text(defender.ca.toString()),
    ];
  }

  Expanded _buildResultContent(BuildContext context, DiceThrowedState state) {
    String textResult = "";
    IconData iconData;
    Color colorResult;

    switch (state.attackResult) {
      case AttackResult.SUCCESS:
        textResult = "Succès";
        iconData = Icons.check_circle;
        colorResult = Colors.green;
        break;
      case AttackResult.CRITICAL_SUCCESS:
        textResult = "Succès critique !!";
        iconData = Icons.star;
        colorResult = Colors.greenAccent;
        break;
      case AttackResult.FAIL:
        textResult = "Échec";
        iconData = Icons.cancel;
        colorResult = Colors.red;
        break;
      case AttackResult.CRITICAL_FAIL:
        textResult = "Échec critique !!";
        iconData = Icons.error;
        colorResult = Colors.redAccent;
        break;
      default:
        textResult = "Erreur";
        iconData = Icons.error_outline;
        colorResult = Colors.grey;
        break;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorResult.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 30, color: colorResult),
            const SizedBox(width: 10),
            Text(
              textResult,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorResult,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDegatsInfoContent(BuildContext context, DiceThrowedState state) {
    Weapon? weapon;
    if (attackType == AttackType.CAC) {
      weapon = attacker.cacWeapon;
    } else if (attackType == AttackType.RANGED) {
      weapon = attacker.distWeapon;
    } else {
      return [];
    }

    int diceNumber = weapon!.diceDegatsNumber;
    if(state.attackResult == AttackResult.CRITICAL_SUCCESS){
      diceNumber = diceNumber * 2;
    }
    const double paddingTop = 30;
    return [
      const Padding(
          padding: EdgeInsets.fromLTRB(0, paddingTop,0, 0 ),
          child: Text("Dés à lancer : "),

      ),
      const SizedBox(width: 8),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, paddingTop,0, 0 ),
        child: Text('${diceNumber}d${weapon!.diceDegatsValue}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) ),
      ),
      const SizedBox(width: 60),
      SizedBox(
        width: 80,
        child: TextFormField(
          controller: _degatsDiceController,
          decoration: const InputDecoration(labelText: 'Résultat'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _degatsDiceController.text = value;
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
      const SizedBox(width: 30),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20,0, 0 ),
        child: FloatingActionButton(
          onPressed: () {
             int result = int.tryParse(_degatsDiceController.text)??0;
             result+=diceNumber*weapon!.diceDegatsBonus;
              context.read<AttackDialogBloc>().add(ResolveDegatsDiceEvent(result));
          },
          backgroundColor: Colors.red,
          child: const SvgIcon(path: 'assets/icons/fight.svg'),
        ),
      ),
    ];
  }

  Widget _buildFinalResultContent(BuildContext context, FinalResultState state){
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Dégats infligés :", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(width: 16),
              Text(state.totalDegats.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.green)),
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    const double sizeBetweenRows = 16;
    return BlocProvider(
        create: (context) {
          return AttackDialogBloc(abilityService, attacker, defender, attackType)..add(InitializeAttackDialogEvent());
        },
        child: BlocConsumer<AttackDialogBloc, AttackDialogState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AttackDialogLoading) {
                return const LoadingDialog();
              } else if (state is AttackDialogLoaded) {
                return AlertDialog(
                  backgroundColor: state.isSuccess == null
                      ? Colors.white
                      : state.isSuccess!
                          ? Colors.green
                          : Colors.red,
                  title: const Center(child: Text("Résolution de l'attaque")),
                  content: SingleChildScrollView(
                    child: ListBody(children: <Widget>[
                      const SizedBox(height: sizeBetweenRows),
                      if(state is FinalResultState)...[
                        _buildFinalResultContent(context, state),
                      ]
                      else if(state is DiceThrowedState)...[

                        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
                        if (state is DiceThrowedState) ...[
                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            _buildResultContent(context, state),
                          ]),
                          if (state.attackResult == AttackResult.SUCCESS || state.attackResult == AttackResult.CRITICAL_SUCCESS) ...[
                            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Expanded(
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: _buildDegatsInfoContent(context, state)),
                              ),
                            ]),
                            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
                          ]
                        ]
                      ]
                      else ...[
                          Row(children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildModifierContent(context, state),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildAbilitySegmentedContent(context, state),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildDiceContent(context, state),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildModifierInfoContent(context, state),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildTargetContent(context, state),
                              ),
                            ),
                          ]),
                          if (state.touchDiceResult != null) ...[
                            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
                            Center(
                              child: FloatingActionButton(
                                onPressed: () {
                                  context.read<AttackDialogBloc>().add(ResolveTouchDiceEvent());
                                },
                                backgroundColor: Colors.red,
                                child: const SvgIcon(path: 'assets/icons/fight.svg'),
                              ),
                            ),

                          ]
                      ]
                    ]),
                  ),
                  actions: [
                    CancelButton(onPressed: () {
                      Navigator.of(context).pop();
                    }),
                    if (state is FinalResultState || (state is DiceThrowedState && (state.attackResult == AttackResult.FAIL || state.attackResult == AttackResult.CRITICAL_FAIL))) ...[
                      ValidationButton(
                          isEnabled: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                            if(state is FinalResultState){
                              fightBloc.add(ResolveAttackEvent(state.totalDegats));
                            }
                          })
                    ]
                  ],
                );
              } else {
                return const IncorrectStateScreen();
              }
            }));
  }
}
