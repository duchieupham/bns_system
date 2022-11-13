import 'package:intl/intl.dart';

class CurrencyUtils {
  const CurrencyUtils._privateConsrtructor();

  static const CurrencyUtils _instance = CurrencyUtils._privateConsrtructor();
  static CurrencyUtils get instance => _instance;

  static final NumberFormat _numberFormat = NumberFormat("##,#0", "en_US");
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  String getCurrencyFormatted(String value) {
    String result = '';
    print('value: $value');
    if (value.isNotEmpty) {
      if (value.length > 3) {
        result = _formatNumber(value.replaceAll(',', ''));
      } else {
        result = value;
      }
    } else {
      result = '0';
    }

    return result;
  }
}
