import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';

class LoginFrame extends StatelessWidget {
  final double width;
  final double height;
  final List<Widget> mobileChildren;
  final List<Widget> webChildren;

  const LoginFrame({
    super.key,
    required this.width,
    required this.height,
    required this.mobileChildren,
    required this.webChildren,
  });

  @override
  Widget build(BuildContext context) {
    return (ScreenResolutionUtils.instance.checkResize(width))
        ? Container(
            width: width * 0.8,
            height: height * 0.8,
            margin: EdgeInsets.only(left: width * 0.1, top: height * 0.1),
            child: Row(
              children: [
                Container(
                  width: width * 0.3,
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg-qr.png'),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.5,
                  height: height,
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: SizedBox(
                      width: width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: webChildren,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: mobileChildren,
          );
  }
}
