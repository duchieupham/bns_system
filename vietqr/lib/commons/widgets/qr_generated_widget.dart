import 'dart:ui';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/default_bank_information.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//set default values (except QR code)
class QRGeneratedWidget extends StatelessWidget {
  final double width;
  final VietQRGenerateDTO vietQRGenerateDTO;
  final BankAccountDTO bankAccountDTO;

  const QRGeneratedWidget({
    Key? key,
    required this.width,
    required this.vietQRGenerateDTO,
    required this.bankAccountDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String vietQRCode = VietQRUtils.instance.generateVietQR(vietQRGenerateDTO);
    return UnconstrainedBox(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            alignment: Alignment.center,
            width: width - 30,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: DefaultTheme.WHITE.withOpacity(0.8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.4,
                  child: Image.asset('assets/images/ic-viet-qr.png'),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DefaultTheme.WHITE,
                    border: Border.all(
                      color: DefaultTheme.GREY_TEXT,
                      width: 0.5,
                    ),
                  ),
                  child: QrImage(
                    data: vietQRCode,
                    version: QrVersions.auto,
                    size: width * 0.5,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-small.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(width * 0.075, width * 0.075),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  'Tên chủ TK: ${bankAccountDTO.bankAccountName.toUpperCase()}',
                  style: const TextStyle(
                    color: DefaultTheme.BLUE_DARK,
                    fontSize: 15,
                  ),
                ),
                //Số tài khoản
                Text(
                  'Số TK: ${BankInformationUtil.instance.hideBankAccount(bankAccountDTO.bankAccount)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: DefaultTheme.BLUE_DARK,
                    fontSize: 15,
                  ),
                ),
                //Tên ngân hàng
                Text(
                  bankAccountDTO.bankName,
                  style: const TextStyle(
                    color: DefaultTheme.BLUE_DARK,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}