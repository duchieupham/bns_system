import 'package:flutter/material.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool check;
  final bool resize;
  final double edge;

  const CheckBoxWidget(
      {Key? key, required this.check, required this.resize, required this.edge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      (check) ? 'assets/images/ic-checked.png' : 'assets/images/ic-uncheck.png',
      width: (resize) ? edge : 25,
      height: (resize) ? edge : 25,
      fit: BoxFit.contain,
    );
  }
}
