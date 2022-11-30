import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  String _bankSelected = 'Chọn ngân hàng';
  String _birthDate = '01/01/1970';
  bool _gender = false;

  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;

  get phoneErr => _isPhoneErr;
  get passwordErr => _isPasswordErr;
  get confirmPassErr => _isConfirmPassErr;

  get gender => _gender;
  get birthDate => _birthDate;
  get bankSelected => _bankSelected;

  void updateErrs({
    required bool phoneErr,
    required bool passErr,
    required bool confirmPassErr,
  }) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;

    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr && !_isPasswordErr && !_isConfirmPassErr;
  }

  void updateBankSelected(String value) {
    _bankSelected = value;
    notifyListeners();
  }

  void updateGender(bool value) {
    _gender = value;
    notifyListeners();
  }

  void updateBirthDate(String value) {
    _birthDate = value;
    notifyListeners();
  }

  List<String> getListAvailableBank() {
    List<String> result = [];
    result.add(_bankSelected);
    result.addAll(BankInformationUtil.instance.getAvailableAddingBanks());
    return result;
  }
}
