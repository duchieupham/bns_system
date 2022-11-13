import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateQRProvider with ChangeNotifier {
  String _transactionAmount = '0';
  String _currencyFormatted = '0';

  final NumberFormat numberFormat = new NumberFormat("##,#0", "en_US");
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  get transactionAmount => _transactionAmount;
  get currencyFormatted => _currencyFormatted;

  void reset() {
    _transactionAmount = '0';
    _currencyFormatted = '0';
    notifyListeners();
  }

  void updateTransactionAmount(String value) {
    _transactionAmount += value;
    updateCurrencyFormat(_transactionAmount);
    notifyListeners();
  }

  void removeTransactionAmount() {
    if (_transactionAmount.length == 1 || _transactionAmount.isEmpty) {
      _transactionAmount = '0';
      _currencyFormatted = '0';
    } else {
      _transactionAmount =
          _transactionAmount.substring(0, _transactionAmount.length - 1);
      updateCurrencyFormat(_transactionAmount);
    }

    notifyListeners();
  }

  void updateCurrencyFormat(String value) {
    if (value.isNotEmpty && value.characters.first == '0') {
      value = value.substring(1);
      /* if (value.length > 3) {
        _currencyFormatted = numberFormat.format(value);
      } else {
        _currencyFormatted = value;
      }*/
      if (value.isEmpty) {
        _currencyFormatted = '0';
      } else if (value.length > 3) {
        _currencyFormatted = _formatNumber(value.replaceAll(',', ''));
      } else {
        _currencyFormatted = value;
      }
    } else {
      _currencyFormatted = '0';
    }
    notifyListeners();
  }
}
