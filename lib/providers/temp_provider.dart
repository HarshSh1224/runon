import 'package:flutter/material.dart';

class TempProvider with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
