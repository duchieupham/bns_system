import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features_mobile/generate_qr/widgets/cal_keyboard_widget.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputTAWidget extends StatefulWidget {
  const InputTAWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputTAWidget();
}

class _InputTAWidget extends State<InputTAWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Row(
          children: [
            Container(
              width: width * 0.6 - 15,
              alignment: Alignment.centerRight,
              child: Consumer<CreateQRProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.currencyFormatted,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: DefaultTheme.GREEN,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  );
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Container(
              width: width * 0.4 - 15,
              alignment: Alignment.centerLeft,
              child: const Text(
                'VND',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        const Text('Nhập số tiền cần thanh toán'),
        CalKeyboardWidget(width: width, height: height * 0.45),
      ],
    );
  }
}
