import 'package:flutter/foundation.dart';

class ChangeIndex extends ChangeNotifier{
  int selectedLanguageIndex = 0;

  void selectEnglish() {
    selectedLanguageIndex = 0;
    notifyListeners();
  }

  void selectTurkmen() {
    selectedLanguageIndex = 1;
    notifyListeners();
  }
}