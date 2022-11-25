import 'dart:ui';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRStatisticWidget extends StatelessWidget {
  final BankAccountDTO bankAccountDTO;
  final bool? isWeb;

  const QRStatisticWidget({
    Key? key,
    required this.bankAccountDTO,
    this.isWeb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VietQRGenerateDTO dto = VietQRGenerateDTO(
      cAIValue: VietQRUtils.instance.generateCAIValue(
          bankAccountDTO.bankCode, bankAccountDTO.bankAccount),
      //'0010A00000072701240006970436011090000067890208QRIBFTTA',
      transactionAmountValue: '',
      additionalDataFieldTemplateValue: '',
    );
    String qrCode =
        VietQRUtils.instance.generateVietQRWithoutTransactionAmount(dto);
    double width = MediaQuery.of(context).size.width;
    return (isWeb != null && isWeb!)
        ? Container(
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.asset('assets/images/ic-viet-qr.png'),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DefaultTheme.WHITE,
                      border: Border.all(
                        color: DefaultTheme.GREY_TEXT,
                        width: 0.5,
                      ),
                    ),
                    child: QrImage(
                      data: qrCode,
                      version: QrVersions.auto,
                      size: 150,
                      embeddedImage: const AssetImage(
                          'assets/images/ic-viet-qr-small.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(20, 20),
                      ),
                      backgroundColor: DefaultTheme.WHITE,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    'Tên chủ TK: ${bankAccountDTO.bankAccountName.toUpperCase()}',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 13,
                    ),
                  ),
                  //Số tài khoản
                  Text(
                    'Số TK: ${BankInformationUtil.instance.hideBankAccount(bankAccountDTO.bankAccount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).focusColor,
                      fontSize: 13,
                    ),
                  ),
                  //Tên ngân hàng
                  Text(
                    bankAccountDTO.bankName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        : UnconstrainedBox(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  alignment: Alignment.center,
                  width: width - 60,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          data: qrCode,
                          version: QrVersions.auto,
                          size: width * 0.5,
                          embeddedImage: const AssetImage(
                              'assets/images/ic-viet-qr-small.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(width * 0.075, width * 0.075),
                          ),
                          backgroundColor: DefaultTheme.WHITE,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        'Tên chủ TK: ${bankAccountDTO.bankAccountName.toUpperCase()}',
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontSize: 15,
                        ),
                      ),
                      //Số tài khoản
                      Text(
                        'Số TK: ${BankInformationUtil.instance.hideBankAccount(bankAccountDTO.bankAccount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).focusColor,
                          fontSize: 15,
                        ),
                      ),
                      //Tên ngân hàng
                      Text(
                        bankAccountDTO.bankName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
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
