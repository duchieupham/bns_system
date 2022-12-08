import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Quét mã QR'),
          Expanded(
            child: MobileScanner(
                allowDuplicates: true,
                onDetect: (barcode, args) {
                  print('---bar code: $barcode');
                  print('-----args: $args');
                  print('---qr code url: ${barcode.url}');
                  final String code = barcode.rawValue!;
                  final bytes = barcode.rawBytes!;
                  print('-----code: $code - $bytes');
                  final SnackBar snackBar = SnackBar(
                      content: Text(
                    '$code - $bytes',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  DialogWidget.instance.openContentDialog(
                    context,
                    () {},
                    Text(
                      '$code - $bytes',
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
