import 'package:djd_kids/service/character_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/character.dart';
import '../model/creature.dart';

class DatabaseService {
  static const _dbName = 'dndUtility.db';
  static const _dbVersion = 1;

  static const tableCreatures = 'creatures';
  static const tableCharacters = 'characters';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnCreatureName = 'creatureName';
  static const columnStrength = 'strength';
  static const columnDexterity = 'dexterity';
  static const columnConstitution = 'constitution';
  static const columnIntelligence = 'intelligence';
  static const columnWisdom = 'wisdom';
  static const columnCharisma = 'charisma';
  static const columnDiceHpNumber = 'diceHpNumber';
  static const columnDiceHpValue = 'diceHpValue';
  static const columnDiceHpBonus = 'diceHpBonus';
  static const columnInitiative = 'initiative';
  static const columnHpMax = 'hpMax';
  static const columnHpCurrent = 'hpCurrent';
  static const columnCa = 'ca';


  // Autres colonnes pour les caractéristiques...

  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {

    if (_database != null) return _database!;
    _database = await _initDatabase();
    // TODO A RETIRER POUR TEST
    //await _initDatas();
    return _database!;
  }

  _initDatabase() async {
    //TODO A RETIRER SI NECESSAIRE
   // await _resetDatabase();
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _resetDatabase() async {
    if (kDebugMode) {
      print('Reset database');
    }
    // Supprimez la base de données actuelle
    String path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);

    // Réinitialisez la variable _database
    _database = null;

  }

  Future _onCreate(Database db, int version) async {
    await _createCreatureTable(db);
    await _createCharacterTable(db);
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
        '$columnCharisma INTEGER NOT NULL,'
        '$columnDiceHpNumber INTEGER NOT NULL,'
        '$columnDiceHpValue INTEGER NOT NULL,'
        '$columnDiceHpBonus INTEGER NOT NULL,'
        '$columnCa INTEGER NOT NULL'
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

  Future _createCharacterTable(Database db) async{
    await db.execute('CREATE TABLE $tableCharacters ('
        '$columnId INTEGER PRIMARY KEY,'
        '$columnName TEXT NOT NULL,'
        '$columnCreatureName TEXT NULL,'
        '$columnStrength INTEGER NOT NULL,'
        '$columnDexterity INTEGER NOT NULL,'
        '$columnConstitution INTEGER NOT NULL,'
        '$columnIntelligence INTEGER NOT NULL,'
        '$columnWisdom INTEGER NOT NULL,'
        '$columnCharisma INTEGER NOT NULL,'
        '$columnInitiative INTEGER NULL,'
        '$columnHpMax INTEGER NOT NULL,'
        '$columnHpCurrent INTEGER NOT NULL,'
        '$columnCa INTEGER NOT NULL'
        ')');
  }

  // Insertion d'une nouvelle créature
  Future<void> insertCharacter(Character character) async {
    Database db = await instance.database;
    Map<String, dynamic> row = character.toMap();
    await db.insert(tableCharacters, row);
  }

  Future<List<Character>> getCharacters() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableCharacters);
    return List.generate(maps.length, (i) => Character.fromMap(maps[i]));
  }

  // Mettre à jour une créature
  Future<void> updateCharacter(Character character) async {
    Database db = await instance.database;
    Map<String, dynamic> row = character.toMap();
    int id = row[columnId];
    await db.update(tableCharacters, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Supprimer une créature
  Future<int> deleteCharacter(int id) async {
    Database db = await instance.database;
    return await db.delete(tableCharacters, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> _initDatas() async{
    final CharacterService characterService = CharacterService();
   Creature creature1 = Creature(name: 'Gobelin', strength: 8, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 8, charisma: 8, diceHpNumber: 3, diceHpValue: 6, diceHpBonus: 6, ca: 15);
    Creature creature2 = Creature(name: 'Orc', strength: 16, dexterity: 12, constitution: 16, intelligence: 7, wisdom: 11, charisma: 10, diceHpNumber: 2, diceHpValue: 8, diceHpBonus: 6, ca: 13);
    Creature creature3 = Creature(name: 'Géant des collines', strength: 21, dexterity: 8, constitution: 19, intelligence: 5, wisdom: 9, charisma: 6, diceHpNumber: 10, diceHpValue: 12, diceHpBonus: 40, ca: 13);
    Creature creature4 = Creature(name: 'Géant du givre', strength: 23, dexterity: 9, constitution: 21, intelligence: 7, wisdom: 10, charisma: 12, diceHpNumber: 12, diceHpValue: 12, diceHpBonus: 60, ca: 15);
    Creature creature5 = Creature(name: 'Géant des pierres', strength: 19, dexterity: 8, constitution: 20, intelligence: 10, wisdom: 12, charisma: 16, diceHpNumber: 11, diceHpValue: 12, diceHpBonus: 55, ca: 17);
    Creature creature6 = Creature(name: 'Géant des tempêtes', strength: 25, dexterity: 14, constitution: 23, intelligence: 16, wisdom: 18, charisma: 20, diceHpNumber: 20, diceHpValue: 12, diceHpBonus: 100, ca: 16);

    insertCreature(creature1);
    insertCreature(creature2);
    insertCreature(creature3);
    insertCreature(creature4);
    insertCreature(creature5);
    insertCreature(creature6);

    Character character1 = characterService.initCharacter('Gimli', creature1);
    Character character2 = characterService.initCharacter('Legolas', creature2);
    Character character3 = characterService.initCharacter('Gandalf', creature3);
    Character character4 = characterService.initCharacter('Aragorn', creature4);
    Character character5 = characterService.initCharacter('Boromir', creature5);
    Character character6 = characterService.initCharacter('Frodon', creature6);
    insertCharacter(character1);
    insertCharacter(character2);
    insertCharacter(character3);
    insertCharacter(character4);
    insertCharacter(character5);
    insertCharacter(character6);
  }
}
