import 'package:flutter/material.dart';

class MarketProvider extends ChangeNotifier {
  var _data = {};
  var _open = false;
  var _status = false;

  get data => _data;
  get color => _open;
  get status => _status;

  void setData(data) {
    _data = data;
    notifyListeners();
  }

  void setMarket(status) {
    _open = status;
    notifyListeners();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }
}
