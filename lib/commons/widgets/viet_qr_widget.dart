import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';

class VietQRWidget extends StatelessWidget {
  final double width;
  final double? height;
  final VietQRGenerateDTO vietQRGenerateDTO;
  final BankAccountDTO bankAccountDTO;
  final GlobalKey globalKey;
  final String content;
  final bool? isStatistic;
  final bool? isCopy;
  final double? qrSize;

  const VietQRWidget({
    super.key,
    required this.width,
    required this.bankAccountDTO,
    required this.vietQRGenerateDTO,
    required this.globalKey,
    required this.content,
    this.height,
    this.isStatistic,
    this.isCopy,
    this.qrSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: (isCopy != null && isCopy!)
          ? Stack(
              fit: StackFit.expand,
              children: [
                _buildComponent(context),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    onTap: () async {
                      await FlutterClipboard.copy(getTextSharing()).then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).hintColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.copy_outlined,
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      size: 20,
                    ),
                  ),
                ),
              ],
            )
          : _buildComponent(context),
    );
  }

  Widget _buildComponent(BuildContext context) {
    String vietQRCode = '';
    if (isStatistic != null && isStatistic!) {
      vietQRCode = VietQRUtils.instance
          .generateVietQRWithoutTransactionAmount(vietQRGenerateDTO);
    } else {
      vietQRCode = VietQRUtils.instance.generateVietQR(vietQRGenerateDTO);
    }
    return RepaintBoundaryWidget(
      globalKey: globalKey,
      builder: (key) {
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
              SizedBox(
                width: width,
                child: Text(
                  bankAccountDTO.bankName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              SizedBox(
                width: width * 0.9,
                child: Text(
                  '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankAccountName.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              BoxLayout(
                width: (qrSize != null) ? (qrSize! + 10) : 210,
                borderRadius: 5,
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                bgColor: DefaultTheme.WHITE,
                enableShadow: true,
                child: Column(
                  children: [
                    QrImage(
                      data: vietQRCode,
                      version: QrVersions.auto,
                      size: (qrSize != null) ? qrSize : 200,
                      embeddedImage: const AssetImage(
                          'assets/images/ic-viet-qr-small.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: (qrSize != null)
                            ? Size(qrSize! / 8, qrSize! / 8)
                            : const Size(20, 20),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/images/ic-viet-qr.png',
                            width: (qrSize != null) ? (qrSize! / 3 - 5) : 75,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Image.asset(
                              'assets/images/ic-napas247.png',
                              width: (qrSize != null) ? (qrSize! / 3 - 5) : 75,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
              (vietQRGenerateDTO.transactionAmountValue != '' &&
                      vietQRGenerateDTO.transactionAmountValue != '0')
                  ? const Padding(padding: EdgeInsets.only(top: 30))
                  : const SizedBox(),
              (vietQRGenerateDTO.transactionAmountValue != '' &&
                      vietQRGenerateDTO.transactionAmountValue != '0')
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
              const Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              (content != '')
                  ? SizedBox(
                      width: width * 0.9,
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: DefaultTheme.GREEN,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  String getTextSharing() {
    String result = '';

    if (vietQRGenerateDTO.transactionAmountValue != '' &&
        vietQRGenerateDTO.transactionAmountValue != '0') {
      if (content != '') {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankAccountName}\nSố tiền: ${vietQRGenerateDTO.transactionAmountValue}\nNội dung: $content';
      } else {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankAccountName}\nSố tiền: ${vietQRGenerateDTO.transactionAmountValue}';
      }
    } else {
      if (content != '') {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankAccountName}\nNội dung: $content';
      } else {
        result =
            '${bankAccountDTO.bankAccount} - ${bankAccountDTO.bankAccountName}';
      }
    }

    return result.trim();
  }
}
