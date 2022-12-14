import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class BoxLayout extends StatelessWidget {
  final double width;
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? height;
  final Color? bgColor;
  final bool? enableShadow;

  const BoxLayout({
    super.key,
    required this.width,
    required this.child,
    this.padding,
    this.borderRadius,
    this.height,
    this.bgColor,
    this.enableShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: (padding != null)
          ? padding
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (bgColor != null) ? bgColor! : Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular((borderRadius != null) ? borderRadius! : 15),
        boxShadow: (enableShadow != null && enableShadow!)
            ? [
                BoxShadow(
                  color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(3, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
