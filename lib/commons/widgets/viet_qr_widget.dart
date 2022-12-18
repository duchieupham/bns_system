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
                      String bankInformationString =
                          '${bankAccountDTO.bankName}\n${bankAccountDTO.bankAccountName.toUpperCase()}\n${bankAccountDTO.bankAccount}';

                      await FlutterClipboard.copy(bankInformationString).then(
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
                    QrImage(
                      data: vietQRCode,
                      version: QrVersions.auto,
                      size: 200,
                      embeddedImage: const AssetImage(
                          'assets/images/ic-viet-qr-small.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(20, 20),
                      ),
                    ),
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
                    const Padding(padding: EdgeInsets.only(top: 10)),
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
      },
    );
  }
}
