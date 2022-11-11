import 'dart:ui';
import 'package:check_sms/features/generate_qr/widgets/cal_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRGeneratorScreen();
}

class _QRGeneratorScreen extends State<QRGeneratorScreen> {
  final TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          TextFormField(
            showCursor: true,
            readOnly: true,
            controller: txtController,
            textAlign: TextAlign.right,
          ),
          const Spacer(),
          Visibility(
            // visible: txtController.text.isNotEmpty,
            visible: true,
            child: InkWell(
              onTap: () {
                _buildSetting(context);
              },
              child: Container(
                width: width,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  // 'Tiếp theo',
                  'Tạo mã QR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          CalKeyboardWidget(
            height: height * 0.4,
            width: width,
            txtController: txtController,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 90)),
        ],
      ),
    );
  }

  _buildSetting(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: ClipRRect(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33.33),
                  color: Theme.of(context).hoverColor,
                ),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 50)),
                    const Text(
                      'Mã QR thanh toán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      alignment: Alignment.center,
                      height: 200,
                      child: QrImage(
                        data:
                            '00020101021238570010A00000072701270006970403011300110123456780208QRIBFTTA530370454061800005802VN62340107NPS68690819thanh toan don hang63042E2E',
                        // data:
                        //     "00020101021138540010A00000072701240006970422011011233555890208QRIBFTTA53037045802VN6304866E",
                        version: QrVersions.auto,
                        size: 200.0,
                        foregroundColor: Theme.of(context).hintColor,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'Xong',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
