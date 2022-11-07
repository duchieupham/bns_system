// ignore_for_file: constant_identifier_names

class VietQRValue {
  //Payload Format Indicator length and value
  static const String PAYLOAD_FORMAT_INDICATOR_LENGTH = '02';
  static const String PAYLOAD_FORMAT_INDICATOR_VALUE = '01';
  //Point of Initiation Method length and value
  static const String POINT_OF_INITIATION_METHOD_LENGTH = '01';
  static const String POINT_OF_INITIATION_METHOD_VALUE = '12';
  //Consumer Account Information length
  static const String MERCHANT_ACCOUNT_INFORMATION_LENGTH = '57';
  //Transaction Currency length and value
  static const String TRANSACTION_CURRENCY_LENGTH = '03';
  static const String TRANSACTION_CURRENCY_VALUE = '704';
  //Country Code length value
  static const String COUNTRY_CODE_LENGTH = '02';
  static const String COUNTRY_CODE_VALUE = 'VN';
  //CRC (Cyclic Redundancy Check) length
  static const String CRC_LENGTH = '04';
}
