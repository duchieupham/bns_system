import 'package:flutter/material.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserEditProvider with ChangeNotifier {
  bool _isAvailableUpdate = false;
  bool _gender =
      UserInformationHelper.instance.getUserInformation().gender == 'true';
  bool _isFirstNameErr = false;
  bool _isOldPassErr = false;
  bool _isNewPassErr = false;
  bool _isConfirmPassErr = false;

  get availableUpdate => _isAvailableUpdate;
  get gender => _gender;
  get firstNameErr => _isFirstNameErr;
  get oldPassErr => _isOldPassErr;
  get newPassErr => _isNewPassErr;
  get confirmPassErr => _isConfirmPassErr;

  void setAvailableUpdate(bool value) {
    _isAvailableUpdate = value;
    notifyListeners();
  }

  void updateGender(bool value) {
    _gender = value;
    notifyListeners();
  }

  void updateErrors(bool firstNameErr) {
    _isFirstNameErr = firstNameErr;
    notifyListeners();
  }

  void updatePasswordErrs(
      bool oldPassErr, bool newPassErr, bool confirmPassErr) {
    _isOldPassErr = oldPassErr;
    _isNewPassErr = newPassErr;
    _isConfirmPassErr = confirmPassErr;
    notifyListeners();
  }

  bool isValidUpdatePassword() {
    return !_isOldPassErr && !_isNewPassErr && !_isConfirmPassErr;
  }

  bool isValidUpdate() {
    return !_isFirstNameErr;
  }

  void resetPasswordErr() {
    _isOldPassErr = false;
    _isNewPassErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  void reset() {
    _isAvailableUpdate = false;
    _isFirstNameErr = false;
    _gender =
        UserInformationHelper.instance.getUserInformation().gender == 'true';
    notifyListeners();
  }
}
