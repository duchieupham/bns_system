import 'package:flutter/cupertino.dart';

class CreateQRPageSelectProvider with ChangeNotifier {
  int _indexSelected = 0;
  int _notificationCount = 0;
  get indexSelected => _indexSelected;
  get notificationCount => _notificationCount;
  void updateIndex(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void updateNotificationCount(int count) {
    _notificationCount = count;
    notifyListeners();
  }
}
