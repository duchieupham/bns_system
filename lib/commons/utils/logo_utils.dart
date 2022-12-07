import 'package:vierqr/commons/enums/bank_name.dart';

class LogoUtils {
  const LogoUtils._privateConsrtructor();

  static const LogoUtils _instance = LogoUtils._privateConsrtructor();

  String getAssetImageBank(AVAILABLE_ADD_BANKNAME bankName) {
    String result = '';
    if (bankName == AVAILABLE_ADD_BANKNAME.SHB) {
      result = 'assets/images/banks/log-shb.png';
    } else if (bankName == AVAILABLE_ADD_BANKNAME.TECHCOMBANK) {
      result = 'assets/images/banks/logo-techcombank.png';
    } else if (bankName == AVAILABLE_ADD_BANKNAME.VIETCOMBANK) {
      result = 'assets/images/banks/logo-vietcombank.png';
    }
    return result;
  }
}
