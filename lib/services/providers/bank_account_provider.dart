import 'package:flutter/cupertino.dart';

class BankAccountProvider with ChangeNotifier {
  int _indexMenu = 0;
  int _indexSelected = 0;
  int _indexOtherSelected = 0;

  get indexMenu => _indexMenu;
  get indexSelected => _indexSelected;
  get indexOtherSelected => _indexOtherSelected;

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
  }
}
