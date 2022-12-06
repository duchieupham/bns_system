import 'package:flutter/material.dart';

class BoxLayout extends StatelessWidget {
  final double width;
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? height;

  const BoxLayout({
    super.key,
    required this.width,
    required this.child,
    this.padding,
    this.borderRadius,
    this.height,
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
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular((borderRadius != null) ? borderRadius! : 15),
      ),
      child: child,
    );
  }
}
