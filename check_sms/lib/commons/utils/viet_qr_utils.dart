// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:check_sms/commons/constants/vietqr/aid.dart';
import 'package:check_sms/commons/constants/vietqr/transfer_service_code.dart';
import 'package:check_sms/commons/constants/vietqr/viet_qr_id.dart';
import 'package:check_sms/commons/constants/vietqr/viet_qr_value.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';
import 'package:crclib/catalog.dart';
import 'package:crclib/crclib.dart';

class VietQRUtils {
  const VietQRUtils._privateConsrtructor();

  static const VietQRUtils _instance = VietQRUtils._privateConsrtructor();
  static VietQRUtils get instance => _instance;

//Tạo QR không bao gồm giá tiền
  String generateVietQRWithoutTransactionAmount(VietQRGenerateDTO dto) {
    String result = '';
    //Một đối tượng dữ liệu bao gồm: ID + Chiều dài + giá trị
    //Payload Format Indicator
    String pfi = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        generateLengthOfValue(VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE) +
        VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE;
    //Point of Initiation Method
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        generateLengthOfValue(VietQRValue.POINT_OF_INITIATION_METHOD_VALUE) +
        VietQRValue.POINT_OF_INITIATION_METHOD_VALUE_STATIC;
    //Consumer Account Information
    String cai = VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID +
        generateLengthOfValue(dto.cAIValue) +
        dto.cAIValue;
    //Transaction Currency
    String tc = VietQRId.TRANSACTION_CURRENCY_ID +
        generateLengthOfValue(VietQRValue.TRANSACTION_CURRENCY_VALUE) +
        VietQRValue.TRANSACTION_CURRENCY_VALUE;
    //Country Code
    String cc = VietQRId.COUNTRY_CODE_ID +
        generateLengthOfValue(VietQRValue.COUNTRY_CODE_VALUE) +
        VietQRValue.COUNTRY_CODE_VALUE;
    //Additional Data Field Template
    // String adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
    //   generateLengthOfValue(dto.additionalDataFieldTemplateValue) +
    // dto.additionalDataFieldTemplateValue;
    //CRC ID + CRC Length + CRC value (Cyclic Redundancy Check)
    String crcValue = generateCRC(pfi +
        poim +
        cai +
        tc +
        cc +
        //  adft +
        VietQRId.CRC_ID +
        VietQRValue.CRC_LENGTH);
    String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + crcValue;
    result = pfi + poim + cai + tc + cc /*+ adft*/ + crc;
    return result;
  }

//Tạo QR động đến tài khoản
  String generateVietQR(VietQRGenerateDTO dto) {
    String result = '';
    //Một đối tượng dữ liệu bao gồm: ID + Chiều dài + giá trị
    //Payload Format Indicator
    String pfi = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        generateLengthOfValue(VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE) +
        VietQRValue.PAYLOAD_FORMAT_INDICATOR_VALUE;
    //Point of Initiation Method
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        generateLengthOfValue(VietQRValue.POINT_OF_INITIATION_METHOD_VALUE) +
        VietQRValue.POINT_OF_INITIATION_METHOD_VALUE;
    //Consumer Account Information
    String cai = VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID +
        generateLengthOfValue(dto.cAIValue) +
        dto.cAIValue;
    //Transaction Currency
    String tc = VietQRId.TRANSACTION_CURRENCY_ID +
        generateLengthOfValue(VietQRValue.TRANSACTION_CURRENCY_VALUE) +
        VietQRValue.TRANSACTION_CURRENCY_VALUE;
    //Transaction Amount
    String ta = VietQRId.TRANSACTION_AMOUNT_ID +
        generateLengthOfValue(dto.transactionAmountValue) +
        dto.transactionAmountValue;
    //Country Code
    String cc = VietQRId.COUNTRY_CODE_ID +
        generateLengthOfValue(VietQRValue.COUNTRY_CODE_VALUE) +
        VietQRValue.COUNTRY_CODE_VALUE;
    //Additional Data Field Template
    String adft = '';
    if (dto.additionalDataFieldTemplateValue.isNotEmpty) {
      adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
          generateLengthOfValue(dto.additionalDataFieldTemplateValue) +
          dto.additionalDataFieldTemplateValue;
    } else {
      adft = VietQRId.ADDITIONAL_DATA_FIELD_TEMPLATE_ID +
          generateLengthOfValue(' ') +
          ' ';
    }
    //CRC ID + CRC Length + CRC value (Cyclic Redundancy Check)
    String crcValue = '';
    if (dto.additionalDataFieldTemplateValue.isEmpty) {
      crcValue = generateCRC(pfi +
          poim +
          cai +
          tc +
          ta +
          cc +
          VietQRId.CRC_ID +
          VietQRValue.CRC_LENGTH);
      String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + crcValue;
      result = pfi + poim + cai + tc + ta + cc + crc;
    } else {
      crcValue = generateCRC(pfi +
          poim +
          cai +
          tc +
          ta +
          cc +
          adft +
          VietQRId.CRC_ID +
          VietQRValue.CRC_LENGTH);
      String crc = VietQRId.CRC_ID + VietQRValue.CRC_LENGTH + crcValue;
      result = pfi + poim + cai + tc + ta + cc + adft + crc;
    }
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
  //poimValue = BNB ID + Consumer ID
  //- Định danh ACQ ID/ BNB ID: các ngân hàng tại Việt Nam sử dụng mã BIN cấp bởi
  //NHNN. VD: 970403.
  //- Định danh Merchant ID/ Consumer ID có định dạng chữ số (ANS) với độ dài tối đa 19
  // ký tự. Giá trị của Merchant ID có thể là Mã số thuế, mã số doanh nghiệp, mã số đăng
  // ký hộ kinh doanh hoặc mã định danh, chuỗi ký tự tùy chọn theo quy định cụ thể của
  // ngân hàng thanh toán. Giá trị của Consumer ID là số tài khoản của khách hàng mở tại
  // NH thụ hưởng (BNB ID).
  String generateMerchantAccountInformationValue(String poimValue) {
    String result = '';
    //Định danh duy nhất toàn cầu
    String guid = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID +
        generateLengthOfValue(AID.AID_NAPAS) +
        AID.AID_NAPAS;
    //Tổ chức thụ hưởng
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID +
        generateLengthOfValue(poimValue) +
        poimValue;
    //Mã dịch vụ - Transfer Service code
    String tsc = VietQRId.TRANSFER_SERVCICE_CODE +
        generateLengthOfValue(
            TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT) +
        TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT;
    result = guid + poim + tsc;
    return result;
  }
}
