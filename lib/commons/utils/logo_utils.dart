import 'package:vierqr/commons/enums/bank_name.dart';

class LogoUtils {
  const LogoUtils._privateConsrtructor();

  static const LogoUtils _instance = LogoUtils._privateConsrtructor();
  static LogoUtils get instance => _instance;

  String getAssetImageBank(String bankName) {
    String result = '';
    bankName = 'AVAILABLE_ADD_BANKNAME.$bankName';
    if (bankName == AVAILABLE_ADD_BANKNAME.SHB.toString()) {
      result = 'assets/images/banks/ic-shb.png';
    } else if (bankName == AVAILABLE_ADD_BANKNAME.MBBANK.toString()) {
      result = 'assets/images/banks/ic-mb.png';
    } else {
      result = 'assets/images/ic-viet-qr-small.png';
    }
    // } else if (bankName == AVAILABLE_ADD_BANKNAME.TECHCOMBANK) {
    //   result = 'assets/images/banks/logo-techcombank.png';
    // } else if (bankName == AVAILABLE_ADD_BANKNAME.VIETCOMBANK) {
    //   result = 'assets/images/banks/logo-vietcombank.png';
    // }
    return result;
  }
}
