import 'package:djd_kids/service/character_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import '../model/character.dart';
import '../model/creature.dart';
import '../model/weapon.dart';

class DatabaseService {
  static const _dbName = 'dndUtility.db';
  static const _dbVersion = 1;

  static const tableCreatures = 'creatures';
  static const tableCharacters = 'characters';
  static const tableWeapons = 'weapons';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnCreatureName = 'creatureName';
  static const columnCreatureId = 'creatureId';
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
  static const columnCacAbility = 'cacAbility';
  static const columnDiceDegatsNumber = 'diceDegatsNumber';
  static const columnDiceDegatsValue = 'diceDegatsValue';
  static const columnDiceDegatsBonus = 'diceDegatsBonus';
  static const columnCacWeaponId = 'cacWeaponId';
  static const columnDistWeaponId = 'distWeaponId';
  static const columnWeaponType = 'weaponType';

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
    //await _resetDatabase();
    String path = join(await getDatabasesPath(), _dbName);
    Database database= await openDatabase(path,version: _dbVersion, onCreate: _onCreate);

    return database;
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
    await _createWeaponTable(db);
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
        '$columnCacAbility TEXT NOT NULL,'
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
    List<Creature> results =List.generate(maps.length, (i) => Creature.fromMap(maps[i]));
    return results;
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
        '$columnCreatureId INTEGER NULL,'
        '$columnStrength INTEGER NOT NULL,'
        '$columnDexterity INTEGER NOT NULL,'
        '$columnConstitution INTEGER NOT NULL,'
        '$columnIntelligence INTEGER NOT NULL,'
        '$columnWisdom INTEGER NOT NULL,'
        '$columnCharisma INTEGER NOT NULL,'
        '$columnInitiative INTEGER NULL,'
        '$columnHpMax INTEGER NOT NULL,'
        '$columnHpCurrent INTEGER NOT NULL,'
        '$columnCa INTEGER NOT NULL,'
        '$columnCacAbility TEXT NOT NULL,'
        '$columnCacWeaponId INTEGER NULL,'
        '$columnDistWeaponId INTEGER NULL'
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

  Future<Character> getCharacterById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableCharacters, where: '$columnId = ?', whereArgs: [id]);
    return Character.fromMap(maps[0]);
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

  Future _createWeaponTable(Database db) async{
    await db.execute('CREATE TABLE $tableWeapons ('
        '$columnId INTEGER PRIMARY KEY,'
        '$columnName TEXT NOT NULL,'
        '$columnDiceDegatsNumber INTEGER NOT NULL,'
        '$columnDiceDegatsValue INTEGER NOT NULL,'
        '$columnDiceDegatsBonus INTEGER NOT NULL,'
        '$columnWeaponType TEXT NOT NULL'
        ')');
  }


  // Insertion d'une nouvelle créature
  Future<void> insertWeapon(Weapon weapon) async {
    Database db = await instance.database;
    Map<String, dynamic> row = weapon.toMap();
    await db.insert(tableWeapons, row);
  }


  Future<List<Weapon>> getWeapons() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableWeapons);
    List<Weapon> results =List.generate(maps.length, (i) => Weapon.fromMap(maps[i]));
    return results;
  }

  Future<List<Weapon>> getWeaponsByType(WeaponType weaponType) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableWeapons, where : '$columnWeaponType = ?', whereArgs: [weaponType.name]);
    List<Weapon> results =List.generate(maps.length, (i) => Weapon.fromMap(maps[i]));
    return results;
  }

  Future<Weapon> getWeaponById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableWeapons, where: '$columnId = ?', whereArgs: [id]);
    return Weapon.fromMap(maps[0]);
  }

  // Mettre à jour une créature
  Future<void> updateWeapon(Weapon weapon) async {
    Database db = await instance.database;
    Map<String, dynamic> row = weapon.toMap();
    int id = row[columnId];
    await db.update(tableWeapons, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Supprimer une créature
  Future<int> deleteWeapon(int id) async {
    Database db = await instance.database;
    return await db.delete(tableWeapons, where: '$columnId = ?', whereArgs: [id]);
  }


  Future<void> _initDatas() async{
    print("Init datas");
    final CharacterService characterService = CharacterService();

    Weapon weapon1 = Weapon(name: 'Bâton', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2 = Weapon(name: 'Dague', diceDegatsNumber: 1, diceDegatsValue: 4, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2b = Weapon(name: 'Gourdin', diceDegatsNumber: 1, diceDegatsValue: 4, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2c = Weapon(name: 'Hachette', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2d = Weapon(name: 'Javeline', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE_ET_DISTANCE);
    Weapon weapon2e = Weapon(name: 'Lance', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2f = Weapon(name: 'Marteau léger', diceDegatsNumber: 1, diceDegatsValue: 4, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon7 = Weapon(name: 'Masse d\'armes', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon7a = Weapon(name: 'Massue', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2g = Weapon(name: 'Arbalète légère', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);
    Weapon weapon2a = Weapon(name: 'Arc court', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);
    Weapon weapon2h = Weapon(name: 'Fléchettes', diceDegatsNumber: 1, diceDegatsValue: 4, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);
    Weapon weapon2i = Weapon(name: 'Fronde', diceDegatsNumber: 1, diceDegatsValue: 4, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);
    Weapon weapon2j = Weapon(name: 'Cimeterre', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon2k = Weapon(name: 'Epée à deux mains', diceDegatsNumber: 2, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon3 = Weapon(name: 'Epée courte', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon4 = Weapon(name: 'Epée longue', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon4a = Weapon(name: 'Fléau', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon6 = Weapon(name: 'Hache à deux mains', diceDegatsNumber: 1, diceDegatsValue: 12, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon6a = Weapon(name: 'Hache d\'armes', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon6b = Weapon(name: 'Hallebarde', diceDegatsNumber: 1, diceDegatsValue: 10, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon6c = Weapon(name: 'Maillet d\'armes', diceDegatsNumber: 2, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon8 = Weapon(name: 'Marteau de guerre', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon8a = Weapon(name: 'Morgenstern', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon8b = Weapon(name: 'Rapière', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon8c = Weapon(name: 'Trident', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
    Weapon weapon8d = Weapon(name: 'Arbalète de poing', diceDegatsNumber: 1, diceDegatsValue: 6, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);
    Weapon weapon8e = Weapon(name: 'Arbalète lourde', diceDegatsNumber: 1, diceDegatsValue: 10, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);
    Weapon weapon8f = Weapon(name: 'Arc long', diceDegatsNumber: 1, diceDegatsValue: 8, diceDegatsBonus: 0, weaponType: WeaponType.DISTANCE);

    insertWeapon(weapon1);
    insertWeapon(weapon2);
    insertWeapon(weapon2b);
    insertWeapon(weapon2c);
    insertWeapon(weapon2d);
    insertWeapon(weapon2e);
    insertWeapon(weapon2f);
    insertWeapon(weapon7);
    insertWeapon(weapon7a);
    insertWeapon(weapon2g);
    insertWeapon(weapon2a);
    insertWeapon(weapon2h);
    insertWeapon(weapon2i);
    insertWeapon(weapon2j);
    insertWeapon(weapon2k);
    insertWeapon(weapon3);
    insertWeapon(weapon4);
    insertWeapon(weapon4a);
    insertWeapon(weapon6);
    insertWeapon(weapon6a);
    insertWeapon(weapon6b);
    insertWeapon(weapon6c);
    insertWeapon(weapon8);
    insertWeapon(weapon8a);
    insertWeapon(weapon8b);
    insertWeapon(weapon8c);
    insertWeapon(weapon8d);
    insertWeapon(weapon8e);
    insertWeapon(weapon8f);


    Creature creature1 = Creature(name: 'Gobelin', strength: 8, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 8, charisma: 8, diceHpNumber: 3, diceHpValue: 6, diceHpBonus: 6, ca: 15, cacAbility: CacAbility.DEX);
    Creature creature2 = Creature(name: 'Orc', strength: 16, dexterity: 12, constitution: 16, intelligence: 7, wisdom: 11, charisma: 10, diceHpNumber: 2, diceHpValue: 8, diceHpBonus: 6, ca: 13, cacAbility: CacAbility.FOR);
    Creature creature3 = Creature(name: 'Géant des collines', strength: 21, dexterity: 8, constitution: 19, intelligence: 5, wisdom: 9, charisma: 6, diceHpNumber: 10, diceHpValue: 12, diceHpBonus: 40, ca: 13, cacAbility: CacAbility.FOR);
    Creature creature4 = Creature(name: 'Géant du givre', strength: 23, dexterity: 9, constitution: 21, intelligence: 7, wisdom: 10, charisma: 12, diceHpNumber: 12, diceHpValue: 12, diceHpBonus: 60, ca: 15, cacAbility: CacAbility.FOR);
    Creature creature5 = Creature(name: 'Géant des pierres', strength: 19, dexterity: 8, constitution: 20, intelligence: 10, wisdom: 12, charisma: 16, diceHpNumber: 11, diceHpValue: 12, diceHpBonus: 55, ca: 17, cacAbility: CacAbility.FOR);
    Creature creature6 = Creature(name: 'Géant des tempêtes', strength: 25, dexterity: 14, constitution: 23, intelligence: 16, wisdom: 18, charisma: 20, diceHpNumber: 20, diceHpValue: 12, diceHpBonus: 100, ca: 16, cacAbility: CacAbility.FOR);

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

    Character character1b=Character(name: "Sam", strength: 13, dexterity: 15, constitution: 16, intelligence: 18, wisdom: 20, charisma: 22, hpMax: 100, hpCurrent: 100, ca: 10, cacAbility: CacAbility.FOR);
    Character character2b=Character(name: "Félix", strength: 10, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 12, charisma: 10, hpMax: 50, hpCurrent: 30, ca : 11, cacAbility: CacAbility.DEX);
    Character character3b=Character(name: "Saroumane", strength: 11, dexterity: 10, constitution: 10, intelligence: 10, wisdom: 10, charisma: 8, hpMax: 70, hpCurrent: 7, ca : 13, cacAbility: CacAbility.FOR);
    Character character4b=Character(name: "Sauron", strength: 10, dexterity: 7, constitution: 16, intelligence: 10, wisdom: 10, charisma: 10, hpMax: 80, hpCurrent: 84, ca : 10, cacAbility: CacAbility.FOR);
    Character character5b=Character(name: "Jacques", strength: 10, dexterity: 42, constitution: 10, intelligence: 10, wisdom: 10, charisma: 26, hpMax: 53, hpCurrent: 52, ca : 15, cacAbility: CacAbility.DEX);

    insertCharacter(character1b);
    insertCharacter(character2b);
    insertCharacter(character3b);
    insertCharacter(character4b);
    insertCharacter(character5b);

  }
}
