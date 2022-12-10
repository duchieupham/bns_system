import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';

class QRScanner extends StatelessWidget {
  final MobileScannerController cameraController = MobileScannerController();

  QRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Quét mã QR'),
          Expanded(
            child: MobileScanner(
                controller: cameraController,
                allowDuplicates: false,
                onDetect: (barcode, args) {
                  final String code = barcode.rawValue ?? '';
                  if (code != '') {
                    Navigator.of(context).pop(code);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
