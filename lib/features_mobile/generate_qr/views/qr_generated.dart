import 'dart:ui';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/header_button_widet.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features_mobile/generate_qr/views/create_qr.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QRGenerated extends StatelessWidget {
  final VietQRGenerateDTO vietQRGenerateDTO;
  final BankAccountDTO bankAccountDTO;
  final String content;

  const QRGenerated({
    Key? key,
    required this.bankAccountDTO,
    required this.vietQRGenerateDTO,
    required this.content,
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
                    color: Theme.of(context).canvasColor.withOpacity(0.6),
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
          const Padding(padding: EdgeInsets.only(top: 50)),
          Expanded(
            child: VietQRWidget(
              width: width - 50,
              bankAccountDTO: bankAccountDTO,
              vietQRGenerateDTO: vietQRGenerateDTO,
              globalKey: key,
              content: content,
              isCopy: true,
              isStatistic: true,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 50)),
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
}
