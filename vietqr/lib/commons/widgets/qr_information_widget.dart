import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/additional_data.dart';
import 'package:vierqr/commons/constants/vietqr/default_bank_information.dart';
import 'package:vierqr/commons/constants/vietqr/qr_guid.dart';
import 'package:vierqr/commons/constants/vietqr/transfer_service_code.dart';
import 'package:vierqr/commons/constants/vietqr/viet_qr_id.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//set default values (except QR code)
class QRInformationWidget extends StatelessWidget {
  final double width;

  QRInformationWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String contentQR = 'VietQR';
    String additionalDataFieldTemplateValue =
        AdditionalData.PURPOSE_OF_TRANSACTION_ID +
            VietQRUtils.instance.generateLengthOfValue(contentQR) +
            contentQR;
    String cAIValue = QRGuid.GUID +
        VietQRId.POINT_OF_INITIATION_METHOD_ID +
        VietQRUtils.instance
            .generateLengthOfValue(DefaultBankInformation.DEFAULT_CAI) +
        //change default CAI to generate CAI
        DefaultBankInformation.DEFAULT_CAI +
        VietQRId.TRANSFER_SERVCICE_CODE +
        VietQRUtils.instance.generateLengthOfValue(
            TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT) +
        TransferServiceCode.QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT;
    VietQRGenerateDTO vietQRGenerateDTO = VietQRGenerateDTO(
      cAIValue: cAIValue,
      transactionAmountValue: '0',
      additionalDataFieldTemplateValue: '',
    );
    String vietQRCode = VietQRUtils.instance
        .generateVietQRWithoutTransactionAmount(vietQRGenerateDTO);
    //print('viet QR code: $vietQRCode');

    ///000201
    ///010212
    ///38610010A00000072701240006970436011090000067890208QRIBFTTA
    ///5303704
    ///5303704 (duplicate) (resolved)
    ///Gia tien 0d: 54010
    ///5802VN
    ///62100806Vietqr
    ///63047A12
    ///
    ///without transaction amount
    ///000201
    ///010211
    ///38-61-0010A00000072701240006970436011090000067890208QRIBFTTA
    ///5303704
    ///5303704 (duplicate) (resolved)
    ///5802VN
    ///62100806Vietqr
    ///6304AD30
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
              'Tên chủ TK: ${DefaultBankInformation.FULL_NAME}'.toUpperCase(),
              style: const TextStyle(
                color: DefaultTheme.BLUE_DARK,
                fontSize: 12,
              ),
            ),
            //Số tài khoản
            Text(
              'Số TK: ${BankInformationUtil.instance.hideBankAccount(DefaultBankInformation.DEFAULT_BANK_ACCOUNT)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: DefaultTheme.BLUE_DARK,
                fontSize: 12,
              ),
            ),
            //Tên ngân hàng
            const Text(
              DefaultBankInformation.DEFAULT_BANK_NAME,
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
