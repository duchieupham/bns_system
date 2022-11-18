import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:flutter/cupertino.dart';

class BankSelectProvider with ChangeNotifier {
  //
  String _bankSelected = 'Chọn ngân hàng';
  List<String> _banks = BankInformationUtil.instance.getAvailableAddingBanks();

  get banks => _banks;
  get bankSelected => _bankSelected;

  void updateBankSelected(String value) {
    _bankSelected = value;
    notifyListeners();
  }

  List<String> getListAvailableBank() {
    List<String> result = [];
    result.add(_bankSelected);
    result.addAll(BankInformationUtil.instance.getAvailableAddingBanks());
    return result;
  }
}
