import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  var _data = {};
  get data => _data;

  void setUser(user) {
    _data = user;
    notifyListeners();
  }
}
