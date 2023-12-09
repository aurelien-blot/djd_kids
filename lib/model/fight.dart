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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Fight.fromMap(Map<String, dynamic> map) :
        id = map['id'],
        name = map['name'],
        allies = [],
        enemies = []
  ;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Fight && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}
