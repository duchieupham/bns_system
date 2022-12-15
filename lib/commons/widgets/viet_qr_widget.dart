import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';

class VietQRWidget extends StatelessWidget {
  final double width;
  final double? height;
  final VietQRGenerateDTO vietQRGenerateDTO;
  final BankAccountDTO bankAccountDTO;
  final String content;
  final bool? isStatistic;

  const VietQRWidget({
    super.key,
    required this.width,
    required this.bankAccountDTO,
    required this.vietQRGenerateDTO,
    required this.content,
    this.height,
    this.isStatistic,
  });

  @override
  Widget build(BuildContext context) {
    String vietQRCode = '';
    if (isStatistic != null && isStatistic!) {
      vietQRCode = VietQRUtils.instance
          .generateVietQRWithoutTransactionAmount(vietQRGenerateDTO);
    } else {
      vietQRCode = VietQRUtils.instance.generateVietQR(vietQRGenerateDTO);
    }

    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            bankAccountDTO.bankName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          Text(
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankAccountName.toUpperCase()}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          BoxLayout(
            width: 210,
            borderRadius: 5,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            bgColor: DefaultTheme.WHITE,
            enableShadow: true,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/images/ic-viet-qr.png',
                        width: 75,
                      ),
                      Image.asset(
                        'assets/images/ic-napas247.png',
                        width: 75,
                      ),
                    ],
                  ),
                ),
                QrImage(
                  data: vietQRCode,
                  version: QrVersions.auto,
                  size: 200,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(20, 20),
                  ),
                ),
              ],
            ),
          ),
          (vietQRGenerateDTO.transactionAmountValue != '')
              ? const Padding(padding: EdgeInsets.only(top: 30))
              : const SizedBox(),
          (vietQRGenerateDTO.transactionAmountValue != '')
              ? RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DefaultTheme.GREEN,
                    ),
                    children: [
                      TextSpan(
                        text: CurrencyUtils.instance.getCurrencyFormatted(
                            vietQRGenerateDTO.transactionAmountValue),
                      ),
                      TextSpan(
                        text: ' VND',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          (content != '')
              ? Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: DefaultTheme.GREEN,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
