import 'dart:ui';

import 'package:flutter/material.dart';

class BlurLayout extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const BlurLayout(
      {Key? key,
      required this.width,
      required this.height,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor.withOpacity(0.8),
          ),
          child: child,
        ),
      ),
    );
  }
}
