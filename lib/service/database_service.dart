import 'package:djd_kids/service/character_service.dart';
import 'package:djd_kids/service/extract_json_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import '../model/character.dart';
import '../model/creature.dart';
import '../model/enums.dart';
import '../model/fight.dart';
import '../model/weapon.dart';

class DatabaseService {
  static const _dbName = 'dndUtility.db';
  static const _dbVersion = 1;

  static const tableFight = 'fight';
  static const tableCreatures = 'creatures';
  static const tableCharacters = 'characters';
  static const tableFightCharacters = 'fightCharacters';
  static const tableWeapons = 'weapons';
  static const columnId = 'id';
  static const columnFightId = 'fight_id';
  static const columnTeamType = 'teamType';
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
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    Database database= await openDatabase(path,version: _dbVersion, onCreate: _onCreate);

    return database;
  }

  Future<void> resetDatabase() async {
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
    await _createFightTable(db);
    await _createCreatureTable(db);
    await _createCharacterTable(db);
    await _createFightCharacterTable(db);
    await _createWeaponTable(db);
  }

  Future _createFightTable(Database db) async{
    await db.execute('CREATE TABLE $tableFight ('
        '$columnId INTEGER PRIMARY KEY,'
        '$columnName TEXT NOT NULL'
        ')');
  }

  Future<void> insertFight(Fight fight) async {
    Database db = await instance.database;
    Map<String, dynamic> row = fight.toMap();
    await db.insert(tableFight, row);
  }
  Future<void> deleleteAllFights() async {
    Database db = await instance.database;
    await db.delete(tableFight);
    await db.delete(tableFightCharacters);
  }

  Future<Fight?> searchFight() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableFight);
    if(maps.length == 0){
      return null;
    }
    Fight fight = Fight.fromMap(maps[0]);
    List<Map<String, dynamic>> mapsFightCharacters = await db.query(tableFightCharacters, where: '$columnFightId = ?', whereArgs: [fight.id]);
    List<Weapon> cacWeapons = await getWeaponsByType(WeaponType.MELEE);
    List<Weapon> distWeapons = await getWeaponsByType(WeaponType.DISTANCE);
    for(Map<String, dynamic> map in mapsFightCharacters){
      Character character = Character.fromMap(map);
      if(map[columnCacWeaponId] != null){
        character.cacWeapon = cacWeapons.firstWhere((element) => element.id == map[columnCacWeaponId]);
      }
      else{
        character.cacWeapon = null;
      }
      if(map[columnDistWeaponId] != null){
        character.distWeapon = distWeapons.firstWhere((element) => element.id == map[columnDistWeaponId]);
      }
      else{
        character.distWeapon = null;
      }
      if(map[columnTeamType] == TeamType.allies.name){
        fight.allies.add(character);
      }
      else if(map[columnTeamType] == TeamType.enemies.name){
        fight.enemies.add(character);
      }
    }
    return fight;
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

  Future _createFightCharacterTable(Database db) async{
    await db.execute('CREATE TABLE $tableFightCharacters ('
        '$columnId INTEGER PRIMARY KEY,'
        '$columnFightId INTEGER ,'
        '$columnTeamType TEXT NOT NULL,'
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

  Future<void> updateFightCharacter(Character character) async {
    Database db = await instance.database;
    Map<String, dynamic> row = character.toMap();
    int id = row[columnId];
    await db.update(tableFightCharacters, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> addCharacterToFight(int fightId, Character character, TeamType teamType) async {
    Database db = await instance.database;
    Map<String, dynamic> row = character.toMap();
    row[columnFightId] = fightId;
    row[columnTeamType] = teamType.name;
    await db.insert(tableFightCharacters, row);
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

  Future<Weapon?> getWeaponByName<T>(String name) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableWeapons, where : '$columnName = ?', whereArgs: [name]);
    return Weapon.fromMap(maps[0]);
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


  Future<String> initDatas() async{
    if (kDebugMode) {
      print("Init datas");
    }

    Weapon mainsNues = Weapon(name: 'Mains nues', diceDegatsNumber: 1, diceDegatsValue: 4, diceDegatsBonus: 0, weaponType: WeaponType.MELEE);
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

    await insertWeapon(mainsNues);
    await insertWeapon(weapon1);
    await insertWeapon(weapon2);
    await insertWeapon(weapon2b);
    await insertWeapon(weapon2c);
    await insertWeapon(weapon2d);
    await insertWeapon(weapon2e);
    await insertWeapon(weapon2f);
    await insertWeapon(weapon7);
    await insertWeapon(weapon7a);
    await insertWeapon(weapon2g);
    await insertWeapon(weapon2a);
    await insertWeapon(weapon2h);
    await insertWeapon(weapon2i);
    await insertWeapon(weapon2j);
    await insertWeapon(weapon2k);
    await insertWeapon(weapon3);
    await insertWeapon(weapon4);
    await insertWeapon(weapon4a);
    await insertWeapon(weapon6);
    await insertWeapon(weapon6a);
    await insertWeapon(weapon6b);
    await insertWeapon(weapon6c);
    await insertWeapon(weapon8);
    await insertWeapon(weapon8a);
    await insertWeapon(weapon8b);
    await insertWeapon(weapon8c);
    await insertWeapon(weapon8d);
    await insertWeapon(weapon8e);
    await insertWeapon(weapon8f);


    ExtractJsonService extractJsonService = ExtractJsonService();
    List<Creature> creatures = await extractJsonService.extractCreatureListFromJson();
    for(Creature creature in creatures){
      await insertCreature(creature);
    }
    Character sam=Character(name: "Sam", strength: 10, dexterity: 10, constitution: 10, intelligence: 10, wisdom: 10, charisma: 10, hpMax: 10, hpCurrent: 10, ca: 10, cacAbility: CacAbility.FOR);
    Character felix=Character(name: "Félix", strength: 10, dexterity: 10, constitution: 10, intelligence: 10, wisdom: 10, charisma: 10, hpMax: 10, hpCurrent: 10, ca: 10, cacAbility: CacAbility.FOR);
    await insertCharacter(sam);
    await insertCharacter(felix);

    /*Character character1 = characterService.initCharacter('Gimli', creatures[0]);
      Character character2 = characterService.initCharacter('Legolas', creatures[1]);
      Character character3 = characterService.initCharacter('Gandalf', creatures[2]);
      Character character4 = characterService.initCharacter('Aragorn', creatures[3]);
      Character character5 = characterService.initCharacter('Boromir', creatures[4]);
      Character character6 = characterService.initCharacter('Frodon', creatures[5]);

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
  */
    if (kDebugMode) {
      print("Init datas OK");
    }
    return "ok";
  }
}
