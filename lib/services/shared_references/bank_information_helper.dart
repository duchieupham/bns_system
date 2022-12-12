import 'dart:convert';

import 'package:vierqr/main.dart';

class BankInformationHelper {
  const BankInformationHelper._privateConsrtructor();

  static const BankInformationHelper _instance =
      BankInformationHelper._privateConsrtructor();
  static BankInformationHelper get instance => _instance;

  Future<void> initialBankInformationHelper() async {
    await sharedPrefs.setString('BANK_IDS', '[]');
  }

  Future<void> setBankIds(List<String> bankIds) async {
    await sharedPrefs.setString('BANK_IDS', bankIds.toString());
  }

  List<String> getBankIds() {
    return json
        .decode(sharedPrefs.getString('BANK_IDS')!)
        .cast<String>()
        .toList();
  }
}
