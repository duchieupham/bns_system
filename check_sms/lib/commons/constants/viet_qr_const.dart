// ignore_for_file: constant_identifier_names

class VietQRConst {
  //Cấu trúc dữ liệu gốc gốc của VietQR trong dịch vụ chuyển nhanh NAPAS247
  //Phiên bản dữ liệu
  static const String PAYLOAD_FORMAT_INDICATOR = '00';
  //Phương thức khởi tạo
  final String pointOfInitiationMethod = '01';
  //Thông tin định danh ĐVCNTT
  final String merchantAccountInformation = '38';
  //Mã danh mục ĐVCNTT
  final String merchantCategoryCode = '52';
  //Mã tiền tệ
  final String transactionAmount = '54';
  //Chỉ thị cho Tip và phí giao dịch
  final String tipOrConvenienceIndicator = '55';
  //Giá trị phí cố định
  static const VALUE_OF_CONVENIENCE_FEE_FIXED = '56';
  //Giá trị phí tỷ lệ phần trăm
  static const String VALUE_OF_CONVENIENCE_FEE_PERCENTAGE = '57';
}
