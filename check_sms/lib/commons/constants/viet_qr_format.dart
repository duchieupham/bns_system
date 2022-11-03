// ignore_for_file: constant_identifier_names

class VietQRFormat {
  //Cấu trúc dữ liệu gốc gốc của VietQR trong dịch vụ chuyển nhanh NAPAS247
  //Phiên bản dữ liệu
  static const String PAYLOAD_FORMAT_INDICATOR = '00';
  //Phương thức khởi tạo
  static const String POINT_OF_INITIATION_METHOD = '01';
  //Thông tin định danh ĐVCNTT
  static const String MERCHANT_ACCOUNT_INFORMATION = '38';
  //Mã danh mục ĐVCNTT
  static const String MERCHANT_CATEGORY_CODE = '52';
  //Mã tiền tệ
  static const String TRANSACTION_CURRENCY = '53';
  //Số tiền giao dịch
  static const String TRANSACTION_AMOUNT = '54';
  //Chỉ thị cho Tip và phí giao dịch
  static const String TIP_OR_CONVENIENCE_INDICATOR = '55';
  //Giá trị phí cố định
  static const VALUE_OF_CONVENIENCE_FEE_FIXED = '56';
  //Giá trị phí tỷ lệ phần trăm
  static const String VALUE_OF_CONVENIENCE_FEE_PERCENTAGE = '57';
  //Mã quốc gia
  static const String COUNTRY_CODE = '58';
  //Tên ĐVCNTT
  static const String MERCHANT_NAME = '59';
  //Thành phố của ĐVCNTT
  static const String MERCHANT_CITY = '60';
  //Mã bưu điện
  static const String POSTAL_CODE = '61';
  //Thông tin bổ sung
  static const String ADDITIONAL_DATA_FIELD_TEMPLATE = '62';
  //Thông tin ĐVCNTT khuân mẫu ngôn ngữ thay thế
  static const String MERCHANT_INFORMATION_LANGUAGE_TEMPLATE = '64';
  //Đăng ký bởi EMVCo - RFU for EMVCo
  //65-79
  static const List<String> RFU_FOR_EMVCO = ['65', '66', '67']; //...
  //Các thông tin bổ sung đăng ký dùng trong tương lai - Unreserved Templates
  //80-99
  static const List<String> UNRESERVED_TEMPLATES = ['80', '81', '82']; //...
  //Cyclic Redundancy Check
  static const String CRC = '63';
}
