import 'package:flutter/cupertino.dart';

class BankAccountProvider with ChangeNotifier {
  int _indexMenu = 0;
  int _indexSelected = 0;
  int _indexOtherSelected = 0;

  bool _isGetAccountBalance = false;

  get indexMenu => _indexMenu;
  get indexSelected => _indexSelected;
  get indexOtherSelected => _indexOtherSelected;
  get isGetAccountBalance => _isGetAccountBalance;

  void updateGetAccountBalace(bool value) {
    _isGetAccountBalance = value;
    notifyListeners();
  }

  void updateIndex(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void updateOtherIndex(int index) {
    _indexOtherSelected = index;
    notifyListeners();
  }

  void updateIndexMenu(int index) {
    _indexMenu = index;
    notifyListeners();
  }

  void reset() {
    _indexMenu = 0;
    _indexSelected = 0;
    _indexOtherSelected = 0;
    _isGetAccountBalance = false;
  }
}
