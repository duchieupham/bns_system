import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_web_widget.dart';
import 'package:vierqr/layouts/blur_layout.dart';

class BankManageFrame extends StatelessWidget {
  final double width;
  final Widget mobileChilren;
  final Widget webChildren;

  const BankManageFrame({
    super.key,
    required this.width,
    required this.mobileChilren,
    required this.webChildren,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return (ScreenResolutionUtils.instance.checkHomeResize(width, 700))
        ? Stack(
            children: [
              Image.asset(
                'assets/images/bg-bank-card.png',
                width: width,
                //height: height,
                fit: BoxFit.cover,
              ),
              BlurLayout(
                width: width,
                height: height,
                blur: 50,
                borderRadius: 0,
                opacity: 0.9,
                child: Column(
                  children: [
                    const HeaderWebWidget(
                      title: 'Tài khoản ngân hàng',
                      isSubHeader: true,
                    ),
                    Expanded(child: webChildren),
                  ],
                ),
              ),
            ],
          )
        : mobileChilren;
  }
}
