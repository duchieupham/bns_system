// ignore_for_file: constant_identifier_names

import 'package:check_sms/commons/constants/vietqr/country_code.dart';
import 'package:check_sms/commons/constants/vietqr/transaction_currency.dart';

class VietQRValue {
  //Payload Format Indicator value
  static const String PAYLOAD_FORMAT_INDICATOR_VALUE = '01';
  //Point of Initiation Method value
  static const String POINT_OF_INITIATION_METHOD_VALUE = '12';
  //Transaction Currency value
  static const String TRANSACTION_CURRENCY_VALUE = TransactionCurrency.VND;
  //Country Code value
  static const String COUNTRY_CODE_VALUE = CountryCode.VIETNAM;
  //CRC (Cyclic Redundancy Check) default length
  static const String CRC_LENGTH = '04';
}
