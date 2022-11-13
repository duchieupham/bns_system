import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/viet_qr_utils.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//set default values (except QR code)
class QRGeneratedWidget extends StatelessWidget {
  final double width;
  final VietQRGenerateDTO dto;

  const QRGeneratedWidget({
    Key? key,
    required this.width,
    required this.dto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String vietQRCode = VietQRUtils.instance.generateVietQR(dto);
    return Container(
      width: width,
      height: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            DefaultTheme.GREEN,
            DefaultTheme.BLUE_TEXT,
          ],
        ),
      ),
      child: Container(
        width: width * 0.95,
        height: width * 0.95,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: DefaultTheme.WHITE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.4,
              child: Image.asset('assets/images/ic-viet-qr.jpeg'),
            ),
            //QR Generator widget
            //
            //Information
            QrImage(
              data: vietQRCode,
              version: QrVersions.auto,
              size: width * 0.5,
              embeddedImage:
                  const AssetImage('assets/images/ic-viet-qr-small.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(width * 0.075, width * 0.075),
              ),
            ),
            //Tên chủ tài khoản
            Text(
              'Tên chủ TK: Pham Duc Tuan'.toUpperCase(),
              style: const TextStyle(
                color: DefaultTheme.BLUE_DARK,
                fontSize: 12,
              ),
            ),
            //Số tài khoản
            const Text(
              'Số TK: 900****789',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: DefaultTheme.BLUE_DARK,
                fontSize: 12,
              ),
            ),
            //Tên ngân hàng
            const Text(
              'Ngân hàng TMCP Kỹ thương Việt Nam',
              style: TextStyle(
                color: DefaultTheme.BLUE_DARK,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
