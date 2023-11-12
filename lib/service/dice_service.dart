import 'dart:math';

import 'package:flutter/foundation.dart';

class DiceService {
  final Random _random = Random();

  int rollDice(int number , int faces) {
    int total = 0;
    for (int i = 0; i < number; i++) {
      int diceResult = _random.nextInt(faces) + 1;
      if (kDebugMode) {
        //print(diceResult);
      }
      total += diceResult;

    }
    return total;
  }

}
