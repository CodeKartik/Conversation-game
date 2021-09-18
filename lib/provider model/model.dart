import 'package:flutter/cupertino.dart';

class IncrementCounter extends ChangeNotifier {
  int messageCounter = 0;
  int scoreCounter = 0;
  int reset = 0;
  int get getMessageCounter => messageCounter;

  int get getScoreCounter => scoreCounter;

  int get resetCounter => reset;

  void incrementMessageCounter() {
    messageCounter += 2;
    notifyListeners();
  }

  void incrementScoreCounter() {
    scoreCounter += 1;
    notifyListeners();
  }

  void resetCounters() {
    scoreCounter = 0;
    messageCounter = 0;
    notifyListeners();
  }
}
