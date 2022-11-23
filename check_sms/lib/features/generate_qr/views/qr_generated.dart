import 'dart:ui';
import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/currency_utils.dart';
import 'package:check_sms/commons/utils/share_utils.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/header_button_widet.dart';
import 'package:check_sms/commons/widgets/qr_generated_widget.dart';
import 'package:check_sms/commons/widgets/repaint_boundary_widget.dart';
import 'package:check_sms/features/generate_qr/views/create_qr.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:check_sms/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QRGenerated extends StatelessWidget {
  final VietQRGenerateDTO vietQRGenerateDTO;
  final BankAccountDTO bankAccountDTO;

  const QRGenerated({
    Key? key,
    required this.bankAccountDTO,
    required this.vietQRGenerateDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey key = GlobalKey();
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-qr.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.6),
                  ),
                  child: HeaderButtonWidget(
                    title: 'Mã VietQR Thanh toán',
                    button: InkWell(
                      onTap: () {
                        Provider.of<CreateQRProvider>(context, listen: false)
                            .reset();
                        Provider.of<CreateQRPageSelectProvider>(context,
                                listen: false)
                            .updateIndex(0);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => CreateQR(
                              bankAccountDTO: bankAccountDTO,
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        child: Row(
                          children: const [
                            Text(
                              'Tạo lại mã QR',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: DefaultTheme.GREEN,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.refresh,
                              color: DefaultTheme.GREEN,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          RepaintBoundaryWidget(
            globalKey: key,
            builder: (key) {
              return QRGeneratedWidget(
                width: width * 0.9,
                vietQRGenerateDTO: vietQRGenerateDTO,
                bankAccountDTO: bankAccountDTO,
              );
            },
          ),
          // Text('${dto.transactionAmountValue}'),
          // Text('${dto.additionalDataFieldTemplateValue}'),
          const Spacer(),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: [
                  _buildInformationText(width * 0.9 - 42.5, 'Số tiền:',
                      '${CurrencyUtils.instance.getCurrencyFormatted(vietQRGenerateDTO.transactionAmountValue)} VND'),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: width * 0.9,
                    child: const Text(
                      'Nội dung:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  SizedBox(
                    width: width * 0.9,
                    child: Text(
                      (vietQRGenerateDTO
                              .additionalDataFieldTemplateValue.isEmpty)
                          ? ''
                          : vietQRGenerateDTO.additionalDataFieldTemplateValue
                              .substring(4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          SizedBox(
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  width: width * 0.42,
                  text: 'Trang chủ',
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.GREEN,
                  function: () {
                    Provider.of<CreateQRProvider>(context, listen: false)
                        .reset();
                    Provider.of<CreateQRPageSelectProvider>(context,
                            listen: false)
                        .updateIndex(0);

                    Navigator.pop(context);
                  },
                ),
                ButtonWidget(
                  width: width * 0.42,
                  text: 'Chia sẻ',
                  textColor: DefaultTheme.GREEN,
                  bgColor: Theme.of(context).buttonColor,
                  function: () async {
                    await ShareUtils.instance.shareImage(key);
                  },
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ]),
      ),
    );
  }

  Widget _buildInformationText(double width, String title, String value) {
    return SizedBox(
      width: width,
      child: Row(children: [
        SizedBox(
          width: width * 0.3,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.7,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ]),
    );
  }
}
