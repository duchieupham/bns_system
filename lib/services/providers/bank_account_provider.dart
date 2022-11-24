import 'package:vierqr/models/bank_account_dto.dart';
import 'package:flutter/cupertino.dart';

class BankAccountProvider with ChangeNotifier {
  int _indexSelected = 0;
  List<BankAccountDTO> _bankAccounts = [];

  get indexSelected => _indexSelected;
  get bankAccounts => _bankAccounts;

  void updateIndex(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void addAddBankAccounts(List<BankAccountDTO> list) {
    _bankAccounts.addAll(list);
    notifyListeners();
  }

  void removeBankAccount(String bankCode) {
    _bankAccounts.removeWhere((element) => element.bankCode == bankCode);
    notifyListeners();
  }

  void addBankAccount(BankAccountDTO dto) {
    _bankAccounts.add(dto);
    notifyListeners();
  }
}
