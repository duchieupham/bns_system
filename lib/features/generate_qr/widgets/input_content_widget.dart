import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/features/personal/views/qr_scanner.dart';

class InputContentWidget extends StatelessWidget {
  final TextEditingController msgController;

  const InputContentWidget({
    Key? key,
    required this.msgController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Nội dung',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          width: width - 40,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).cardColor),
          child: TextField(
            controller: msgController,
            autofocus: false,
            maxLength: 99,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Nội dung chứa tối đa 99 ký tự.',
              hintStyle: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: ButtonIconWidget(
              width: 150,
              alignment: Alignment.center,
              icon: Icons.document_scanner_rounded,
              title: 'Quét Barcode',
              bgColor: Theme.of(context).cardColor,
              textColor: DefaultTheme.GREEN,
              function: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => QRScanner(
                      title: 'Quét Barcode',
                    ),
                  ),
                )
                    .then((code) {
                  if (code != null) {
                    if (code.toString().isNotEmpty) {
                      msgController.value = msgController.value.copyWith(
                        text: msgController.text + code.toString(),
                      );
                    }
                  }
                });
              },
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
