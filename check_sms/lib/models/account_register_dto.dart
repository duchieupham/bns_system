import 'dart:convert';

import 'package:check_sms/commons/utils/encrypt_utils.dart';
import 'package:crypto/crypto.dart';

class AccountRegisterDTO {
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String birthdate;
  final bool gender;
  final String phoneNo;
  final String address;
  final String password;
  final String bankAccount;
  final String bankAccountName;
  final String bankCode;
  final String bankName;

  const AccountRegisterDTO({
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.phoneNo,
    required this.address,
    required this.password,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankCode,
    required this.bankName,
  });

  Map<String, dynamic> toUserInformationJson() {
    Map<String, dynamic> data = {};
    data['id'] = userId;
    data['address'] = address;
    data['birthDate'] = birthdate;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['phoneNo'] = phoneNo;
    return data;
  }

  Map<String, dynamic> toUserAccountJson() {
    Map<String, dynamic> data = {};
    data['id'] = userId;
    data['phoneNo'] = phoneNo;
    data['password'] = EncryptUtils.instance.encrypted(phoneNo, password);
    return data;
  }

  Map<String, dynamic> toUserBankJson() {
    Map<String, dynamic> data = {};
    data['id'] = userId;
    data['bankAccount'] = bankAccount;
    data['bankAccountName'] = bankAccountName;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    return data;
  }
}
