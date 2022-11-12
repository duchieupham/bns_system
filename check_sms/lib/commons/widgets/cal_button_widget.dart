import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class CalButtonWidget extends StatelessWidget {
  //size = width = height;
  final double size;
  final String value;
  final VoidCallback function;
  final Color color;
  final Color textColor;

  const CalButtonWidget({
    Key? key,
    required this.size,
    required this.value,
    required this.function,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: size,
        height: size * 3 / 4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          value.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DefaultTheme.GREEN,
            fontWeight: FontWeight.w500,
            fontSize: size / 5,
          ),
        ),
      ),
    );
  }
}
