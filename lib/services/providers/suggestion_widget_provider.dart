import 'package:flutter/material.dart';

class SuggestionWidgetProvider with ChangeNotifier {
  bool _isShowSMSPermission = false;
  bool _isShowUserUpdate = false;

  get showSMSPermission => _isShowSMSPermission;
  get showUserUpdate => _isShowUserUpdate;
  get showSuggestion => _isShowUserUpdate && _isShowSMSPermission;

  void updateSMSPermission(bool value) {
    _isShowSMSPermission = value;
    notifyListeners();
  }

  void updateUserUpdating(bool value) {
    _isShowUserUpdate = value;
    notifyListeners();
  }
}
