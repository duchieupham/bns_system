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
        height: size * 2 / 3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(33.33),
        ),
        child: Text(
          value.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: size / 5,
          ),
        ),
      ),
    );
  }
}
