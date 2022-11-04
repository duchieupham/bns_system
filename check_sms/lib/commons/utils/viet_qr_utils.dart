// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:check_sms/commons/constants/viet_qr_id.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';

class VietQRUtils {
  const VietQRUtils._privateConsrtructor();

  static const VietQRUtils _instance = VietQRUtils._privateConsrtructor();
  static VietQRUtils get instance => _instance;

//Tạo QR động đến tài khoản
  String generateVietQR(VietQRGenerateDTO dto) {
    String result = '';
    //Một đối tượng dữ liệu bao gồm: ID + Chiều dài + giá trị
    //Payload Format Indicator
    String pfi = VietQRId.PAYLOAD_FORMAT_INDICATOR_ID + '02' + '01';
    //Point of Initiation Method
    String poim = VietQRId.POINT_OF_INITIATION_METHOD_ID + '02' + '12';
    //Consumer Account Information
    String cai = VietQRId.MERCHANT_ACCOUNT_INFORMATION_ID + '57' + dto.cAIValue;
    //Transaction Currency
    String tc = VietQRId.TRANSACTION_CURRENCY_ID + '03' + '';

    return result;
  }
}
