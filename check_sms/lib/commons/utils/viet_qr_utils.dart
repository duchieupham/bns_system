// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:check_sms/commons/constants/vietqr/viet_qr_id.dart';
import 'package:check_sms/commons/constants/vietqr/viet_qr_value.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';
import 'package:crclib/catalog.dart';
import 'package:crclib/crclib.dart';

class VietQRUtils {
  const VietQRUtils._privateConsrtructor();

  static const VietQRUtils _instance = VietQRUtils._privateConsrtructor();
  static VietQRUtils get instance => _instance;

//Tạo QR động đến tài khoản
  String generateVietQR(VietQRGenerateDTO dto) {
    String result = '';
    //Một đối tượng dữ liệu bao gồm: ID + Chiều dài + giá trị
    //Payload Format Indicator
    String pfi = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        VietQRValue.PAYLOAD_FORMAT_INDICATOR_LENGTH +
        VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE;
    //Point of Initiation Method
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        VietQRValue.POINT_OF_INITIATION_METHOD_LENGTH +
        VietQRValue.POINT_OF_INITIATION_METHOD_VALUE;
    //Consumer Account Information
    String cai = VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID +
        VietQRValue.MERCHANT_ACCOUNT_INFORMATION_LENGTH +
        dto.cAIValue;
    //Transaction Currency
    String tc = VietQRId.TRANSACTION_CURRENCY_ID +
        VietQRValue.TRANSACTION_CURRENCY_LENGTH +
        VietQRValue.TRANSACTION_CURRENCY_VALUE;
    //Transaction Amount
    String ta = VietQRId.TRANSACTION_AMOUNT_ID +
        dto.transactionAmountLength +
        dto.transactionAmountValue;
    //Country Code
    String cc = VietQRId.COUNTRY_CODE_ID +
        VietQRValue.COUNTRY_CODE_LENGTH +
        VietQRValue.COUNTRY_CODE_VALUE;
    //Additional Data Field Template
    String adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
        dto.additionalDataFieldTemplateLength +
        dto.additionalDataFieldTemplateValue;
    //CRC
    String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + dto.crcValue;
    result = pfi + poim + cai + tc + ta + cc + adft + crc;
    return result;
  }

//Trả về thông tin độ dài của một chuỗi
  String generateLengthOfValue(String value) {
    String result = '';
    if (value.isNotEmpty) {
      int valueLength = value.length;
      if (valueLength < 10) {
        result = '0$valueLength';
      } else {
        result = valueLength.toString();
      }
    }
    return result;
  }

//Tạo mã CRC theo chuẩn CRC-16/CCITT-FALSE
  String generateCRC(String value) {
    String result = '';
    CrcValue crcValue = Crc16CcittFalse().convert(utf8.encode(value));
    result = crcValue.toRadixString(16).toString().toUpperCase();
    return result;
  }

  //Tạo mã thông tin định danh
  String generateMerchantAccountInformationValue() {
    String result = '';
    //Định danh duy nhất toàn cầu
    //Tổ chức thụ hưởng
    //Mã dịch vụ
    return result;
  }
}
