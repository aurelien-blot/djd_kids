import 'package:flutter/material.dart';

import '../model/character.dart';

class InitiativeBand extends StatelessWidget {
  final List<Character> charactersByInitiative; // Assurez-vous que cette liste est triée par ordre d'initiative

  const InitiativeBand({Key? key, required this.charactersByInitiative}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: charactersByInitiative.map((character) => _buildCharacterTile(character)).toList(),
      ),
    );
  }

  Widget _buildCharacterTile(Character character) {
    String title = character.name;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/characters/anonym.jpg'),
          ),
          Text(title),
        ],
      ),
    );
  }
}