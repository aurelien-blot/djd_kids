import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/creature.dart';

class DatabaseService {
  static const _dbName = 'dndUtility.db';
  static const _dbVersion = 1;

  static const tableCreatures = 'creatures';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnStrength = 'strength';
  static const columnDexterity = 'dexterity';
  static const columnConstitution = 'constitution';
  static const columnIntelligence = 'intelligence';
  static const columnWisdom = 'wisdom';
  static const columnCharisma = 'charisma';


  // Autres colonnes pour les caractéristiques...

  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    //await _resetDatabase();
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _resetDatabase() async {
    print('Reset database');
    // Supprimez la base de données actuelle
    String path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);

    // Réinitialisez la variable _database
    _database = null;

  }

  Future _onCreate(Database db, int version) async {
    await _createCreatureTable(db);
  }

  Future _createCreatureTable(Database db) async{
    await db.execute('CREATE TABLE $tableCreatures ('
        '$columnId INTEGER PRIMARY KEY,'
        '$columnName TEXT NOT NULL,'
        '$columnStrength INTEGER NOT NULL,'
        '$columnDexterity INTEGER NOT NULL,'
        '$columnConstitution INTEGER NOT NULL,'
        '$columnIntelligence INTEGER NOT NULL,'
        '$columnWisdom INTEGER NOT NULL,'
        '$columnCharisma INTEGER NOT NULL'
        ')');
  }

  // Insertion d'une nouvelle créature
  Future<void> insertCreature(Creature creature) async {
    Database db = await instance.database;
    Map<String, dynamic> row = creature.toMap();
    await db.insert(tableCreatures, row);
  }


  Future<List<Creature>> getCreatures() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableCreatures);
    return List.generate(maps.length, (i) => Creature.fromMap(maps[i]));
  }

  // Mettre à jour une créature
  Future<void> updateCreature(Creature creature) async {
    Database db = await instance.database;
    Map<String, dynamic> row = creature.toMap();
    int id = row[columnId];
    await db.update(tableCreatures, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Supprimer une créature
  Future<int> deleteCreature(int id) async {
    Database db = await instance.database;
    return await db.delete(tableCreatures, where: '$columnId = ?', whereArgs: [id]);
  }
}
