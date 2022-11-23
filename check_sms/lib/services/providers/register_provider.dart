import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  String _bankSelected = 'Chọn ngân hàng';
  String _birthDate = '01/01/1970';
  bool _gender = false;

  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;
  bool _isFirstNameErr = false;
  bool _isLastNameErr = false;
  bool _isBankSelectedErr = false;
  bool _isBankAccountErr = false;
  bool _isBankAccountNameErr = false;

  get phoneErr => _isPhoneErr;
  get passwordErr => _isPasswordErr;
  get confirmPassErr => _isConfirmPassErr;
  get firstNameErr => _isFirstNameErr;
  get lastNameErr => _isLastNameErr;
  get bankSelectedErr => _isBankSelectedErr;
  get bankAccountErr => _isBankAccountErr;
  get bankAccountNameErr => _isBankAccountNameErr;

  get gender => _gender;
  get birthDate => _birthDate;
  get bankSelected => _bankSelected;

  void updateErrs(
      {required bool phoneErr,
      required bool passErr,
      required bool confirmPassErr,
      required bool firstNameErr,
      required bool lastNameErr,
      required bool bankSelectedErr,
      required bool bankAccountErr,
      required bool bankAccountNameErr}) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;
    _isFirstNameErr = firstNameErr;
    _isLastNameErr = lastNameErr;
    _isBankSelectedErr = bankSelectedErr;
    _isBankAccountErr = bankAccountErr;
    _isBankAccountNameErr = bankAccountNameErr;
    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr &&
        !_isPasswordErr &&
        !_isConfirmPassErr &&
        !_isFirstNameErr &&
        !_isLastNameErr &&
        !_isBankSelectedErr &&
        !_isBankAccountErr &&
        !_isBankAccountNameErr;
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
