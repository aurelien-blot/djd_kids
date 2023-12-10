import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/character/characters_bloc.dart';
import '../bloc/character/characters_event.dart';
import '../bloc/character/characters_state.dart';
import '../model/character.dart';
import '../widget/character_dialog.dart';
import '../widget/loading_dialog.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  void _addOrEditCharacter(BuildContext context, Character? character) async {
    // Capturez le Bloc une fois avant de lancer des opérations asynchrones
    final charactersBloc = context.read<CharactersBloc>();

    // Affichez la boîte de dialogue
    final result = await showDialog<Character>(
      context: context,
      builder: (ctx) => CharacterDialog(character: character),
    );

    // Après la boîte de dialogue, vérifiez si le résultat n'est pas null
    // et si le widget est toujours dans l'arbre des widgets.
    if (result != null) {
      if (character == null) {
        charactersBloc.add(AddCharacterEvent(result));
      } else {
        charactersBloc.add(EditCharacterEvent(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<CharactersBloc>().add(LoadCharacters());

    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoading) {
          return const LoadingDialog();
        }
        if (state is CharactersLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _addOrEditCharacter(context, null);
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
                      DataColumn(label: Text('Personnage')),
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
                    rows: state.characters.map((character) => DataRow(
                      cells: [
                        DataCell(Text(character.name??''), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.strength.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.dexterity.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.constitution.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.intelligence.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.wisdom.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.charisma.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.ca.toString()), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.cacAbility.name), onTap: () => _addOrEditCharacter(context, character)),
                        DataCell(Text(character.hpMax.toString()), onTap: () => _addOrEditCharacter(context, character)),
                      ],
                    )).toList(),
                  ),
                ),
              )
            ],
          );
        }
        if (state is CharactersError) {
          return const Center(child: Text('Erreur de chargement des personnages'));
        }
        return const LoadingDialog();
      },
    );
  }
}
