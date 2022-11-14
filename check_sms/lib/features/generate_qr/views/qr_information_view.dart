import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/dialog_widget.dart';
import 'package:check_sms/commons/widgets/qr_information_widget.dart';
import 'package:check_sms/features/generate_qr/views/create_qr.dart';
import 'package:flutter/material.dart';

class QRInformationView extends StatelessWidget {
  const QRInformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*const Text(
            'Mã QR của bạn',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),*/
          const Text(
            'Mã QR này là mã QR tĩnh và không chứa thông tin số tiền thanh toán.',
            style: TextStyle(
                color: DefaultTheme.GREY_TEXT, fontStyle: FontStyle.italic),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Align(
            alignment: Alignment.center,
            child: QRInformationWidget(width: width * 0.9),
          ),
          const Spacer(),
          ButtonWidget(
            width: width,
            text: 'Chia sẻ mã QR của bạn',
            textColor: DefaultTheme.WHITE,
            bgColor: DefaultTheme.GREEN,
            function: () {
              DialogWidget.instance.openTransactionFormattedDialog(
                context,
                'Viettin Bank',
                'VietinBank:21/01/2022 09:20|TK:115000067275|GD:-1,817,432VND|SDC:160,063,611VND|ND:CT DEN:000522831193 CN CTY TNHH MTV VIEN THONG Q.TE FPT TT HD SO 0000111 ~',
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ButtonWidget(
            width: width,
            text: 'Tạo mã QR thanh toán',
            textColor: DefaultTheme.GREEN,
            bgColor: Theme.of(context).buttonColor,
            function: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateQR(),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  }
}
