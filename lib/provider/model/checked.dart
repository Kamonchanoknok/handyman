import 'package:flutter/material.dart';

class CheckedProvider extends ChangeNotifier {
  var _product = 0;
  var _letter = 0;

  get countProduct => _product;
  get countLetter => _letter;

  void setProduct(count) {
    _product = count;
    notifyListeners();
  }

  void setLetter(count) {
    _letter = count;
    notifyListeners();
  }
}
