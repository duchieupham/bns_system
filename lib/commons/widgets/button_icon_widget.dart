import 'package:flutter/material.dart';

class ButtonIconWidget extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final VoidCallback function;
  final Color bgColor;
  final Color textColor;
  final double? textSize;

  const ButtonIconWidget({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.function,
    required this.bgColor,
    required this.textColor,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(width),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor,
              size: (textSize != null) ? textSize : 15,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(
              title,
              style: TextStyle(
                fontSize: (textSize != null) ? textSize : 15,
                color: textColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}