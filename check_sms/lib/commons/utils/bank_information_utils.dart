import 'package:check_sms/commons/enums/bank_name.dart';

class BankInformationUtil {
  const BankInformationUtil._privateConsrtructor();

  static const BankInformationUtil _instance =
      BankInformationUtil._privateConsrtructor();
  static BankInformationUtil get instance => _instance;

  bool checkBankAddress(String bankName) {
    bool result = false;
    //to fake data to check SMS
    if (bankName == '0909000999') {
      bankName = 'MB Bank';
    }
    if (bankName == '0900000000') {
      bankName = 'Viettin Bank';
    }
    if (bankName == '0909999999') {
      bankName = 'SHB';
    }
    if (bankName == '0909090909') {
      bankName = 'Techcombank';
    }
    if (bankName == '0909090901') {
      bankName = 'SCB';
    }
    if (bankName == '0909090902') {
      bankName = 'VietcomBank';
    }
    //
    bankName = 'BANKNAME.${bankName.trim().replaceAll(' ', '').toUpperCase()}';
    if (BANKNAME.values.toString().contains(bankName)) {
      result = true;
    }
    return result;
  }

  bool checkAvailableAddress(String bankName) {
    bool result = false;

    //to fake data to check SMS
    if (bankName == '0909000999') {
      bankName = 'MB Bank';
    }
    if (bankName == '0900000000') {
      bankName = 'Viettin Bank';
    }
    if (bankName == '0909999999') {
      bankName = 'SHB';
    }
    if (bankName == '0909090909') {
      bankName = 'Techcombank';
    }
    if (bankName == '0909090901') {
      bankName = 'SCB';
    }
    if (bankName == '0909090902') {
      bankName = 'VietcomBank';
    }
    //
    bankName = 'BANKNAME.${bankName.trim().replaceAll(' ', '').toUpperCase()}';
    if (AVAILABLE_FORMAT_BANKNAME.values.toString().contains(bankName)) {
      result = true;
    }
    return result;
  }

  bool checkAvailableGenerateBank(String bankName) {
    bool result = false;

    //to fake data to check SMS
    if (bankName == '0909000999') {
      bankName = 'MB Bank';
    }
    if (bankName == '0900000000') {
      bankName = 'Viettin Bank';
    }
    if (bankName == '0909999999') {
      bankName = 'SHB';
    }
    if (bankName == '0909090909') {
      bankName = 'Techcombank';
    }
    if (bankName == '0909090901') {
      bankName = 'SCB';
    }
    if (bankName == '0909090902') {
      bankName = 'VietcomBank';
    }
    //
    bankName = 'BANKNAME.${bankName.trim().replaceAll(' ', '').toUpperCase()}';
    if (AVAILABLE_ADD_BANKNAME.values.toString().contains(bankName)) {
      result = true;
    }
    return result;
  }

  String getBankName(String address) {
    //to fake data to check SMS
    if (address == '0909000999') {
      address = 'MB Bank';
    }
    if (address == '0900000000') {
      address = 'Viettin Bank';
    }
    if (address == '0909999999') {
      address = 'SHB';
    }
    if (address == '0909090909') {
      address = 'TechcomBank';
    }
    if (address == '0909090901') {
      address = 'SCB';
    }
    if (address == '0909090902') {
      address = 'VietcomBank';
    }
    String result =
        'BANKNAME.${address.trim().replaceAll(' ', '').toUpperCase()}';
    return result;
  }

  bool isIncome(String transaction) {
    bool result = false;
    if (transaction.trim().startsWith('+')) {
      result = true;
    }
    return result;
  }

  String hideBankAccount(String bankAccount) {
    String result = '';
    if (bankAccount.isNotEmpty) {
      result = '${bankAccount.substring(0, 3)}*${bankAccount.substring(3 + 1)}';
      result = '${result.substring(0, 4)}*${result.substring(4 + 1)}';
      result = '${result.substring(0, 5)}*${result.substring(5 + 1)}';
      result = '${result.substring(0, 6)}*${result.substring(6 + 1)}';
    }
    return result;
  }

  List<String> getAvailableAddingBanks() {
    List<String> result = [];
    String prefix = '';
    String suffix = '';
    for (var bankName in AVAILABLE_ADD_BANKNAME.values) {
      prefix = bankName.toString().replaceAll('AVAILABLE_ADD_BANKNAME.', '');
      if (prefix ==
          AVAILABLE_ADD_BANKNAME.SHB
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Ngân hàng TMCP Sài Gòn - Hà Nội';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.TECHCOMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Ngân hàng TMCP Kỹ thương Việt Nam';
      } else if (prefix ==
          AVAILABLE_ADD_BANKNAME.VIETCOMBANK
              .toString()
              .replaceAll('AVAILABLE_ADD_BANKNAME.', '')) {
        suffix = 'Ngân hàng TMCP Ngoại thương Việt Nam';
      }
      String value = '$prefix - $suffix';
      result.add(value);
    }
    return result;
  }
}
