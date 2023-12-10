import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../constants.dart';
import '../model/creature.dart';

class ExtractJsonService {

  Future<List<Creature>> extractCreatureListFromJson() async {
    final String contents = await rootBundle.loadString('assets/creatures/creatures.json');
    final List<dynamic> data = json.decode(contents);
    return data.map((json) => convert(json)).toList();
  }

  Creature convert(json){
    int diceHpNumber=0;
    int diceHpValue=0;
    int diceHpBonus=0;
    String name='';
    int strength=0;
    int dexterity=0;
    int constitution=0;
    int intelligence=0;
    int wisdom=0;
    int charisma=0;
    int ca=0;
    CacAbility cacAbility=CacAbility.FOR;

    try{
      //Si "Hit Points": "135 (18d10 + 36)", récupérer 18, 10 et 36, sinon si "Hit Points": "9 (2d8)", récupérer 2 et 8.
      //Si  "Hit Points": "1 (1d4 - 1)", récupérer 1 et 4 et -1
      //ATTENTION à ne pas récupérer 36) ou 8).
      if (json['Hit Points'].contains('(')) {
        // Extrait les parties entre parenthèses
        String hpDetails = json['Hit Points'].split('(')[1].split(')')[0];

        // Sépare le nombre de dés et la valeur des dés
        List<String> parts = hpDetails.split('d');
        diceHpNumber = int.parse(parts[0]);

        // Vérifie s'il y a un bonus
        if (parts[1].contains('+')) {
          List<String> bonusParts = parts[1].split('+');
          diceHpValue = int.parse(bonusParts[0]);
          diceHpBonus = int.parse(bonusParts[1]);
        }
        else if (parts[1].contains('-')) {
          List<String> malusParts = parts[1].split('-');
          diceHpValue = int.parse(malusParts[0]);
          diceHpBonus = -int.parse(malusParts[1]); // Notez le signe négatif ici
        }
        else {
          diceHpValue = int.parse(parts[1]);
          diceHpBonus = 0; // Pas de bonus
        }
      } else {
        // Format "9 2d8" ou similaire
        List<String> parts = json['Hit Points'].split(' ')[1].split('d');
        diceHpNumber = int.parse(parts[0]);
        diceHpValue = int.parse(parts[1]);
        diceHpBonus = 0; // Pas de bonus
      }


      //Si "Armor Class": "17 (natural armor)", récupérer 17, sinon si "Armor Class": "12", récupérer 12, sinon si  :  "Armor Class": "15 Natural" récupérer 15.
      //Si  10 In Humanoid Form, 11 In Bear And Hybrid Form récupérer 10
      if (json['Armor Class'].contains('(')) {
        // Extrait la partie avant la parenthèse
        String caDetails = json['Armor Class'].split('(')[0].trim();
        ca = int.parse(caDetails);
      } else if (json['Armor Class'].contains('Natural')) {
        // Extrait la partie avant "Natural"
        String caDetails = json['Armor Class'].split('Natural')[0].trim();
        ca = int.parse(caDetails);
      } else if (json['Armor Class'].contains(',')) {
        // Gère les cas comme "10 In Humanoid Form, 11 In Bear And Hybrid Form"
        String caDetails = json['Armor Class'].split(',')[0].split(' ')[0].trim();
        ca = int.parse(caDetails);
      } else {
        // Cas de base, par exemple "12"
        ca = int.parse(json['Armor Class']);
      }

      name=json['name'];
      strength = json['STR']!=null ? int.parse(json['STR']) : 0;
      dexterity = json['DEX']!=null ? int.parse(json['DEX']) : 0;
      constitution = json['CON']!=null ? int.parse(json['CON']) : 0;
      intelligence = json['INT']!=null ? int.parse(json['INT']) : 0;
      wisdom = json['WIS']!=null ? int.parse(json['WIS']) : 0;
      charisma = json['CHA']!=null ? int.parse(json['CHA']) : 0;

    } catch(e){
      print("Erreur lors de la conversion de la créature : ${e.toString()}");
    }

    return Creature(name: name, strength: strength, dexterity: dexterity,
        constitution: constitution, intelligence: intelligence, wisdom: wisdom, charisma: charisma, diceHpNumber: diceHpNumber,
        diceHpValue: diceHpValue, diceHpBonus: diceHpBonus, ca: ca, cacAbility: cacAbility);
  }



}
