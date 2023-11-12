import 'character.dart';

class Fight {
  int? id;
  String name;
  List<Character> allies;
  List<Character> enemies;
  List<Character> orderedByInitiative = [];

  Fight({
    this.id,
    required this.name,
    required this.allies,
    required this.enemies,
  });

}
