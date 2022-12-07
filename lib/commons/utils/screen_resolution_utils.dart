import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenResolutionUtils {
  const ScreenResolutionUtils._privateConsrtructor();

  static const ScreenResolutionUtils _instance =
      ScreenResolutionUtils._privateConsrtructor();
  static ScreenResolutionUtils get instance => _instance;

  bool checkResize(double width) {
    bool check = false;
    check = width >= 600 && kIsWeb;
    return check;
  }

  bool checkHomeResize(double width, double widthResize) {
    bool check = false;
    check = ((width >= widthResize) && kIsWeb);
    return check;
  }

  double getDynamicWidth({
    required double screenWidth,
    required double defaultWidth,
    required double minWidth,
  }) {
    double result = 0;
    if (screenWidth < defaultWidth) {
      result = minWidth;
    } else {
      result = defaultWidth;
    }
    return result;
  }

  bool isWeb() {
    return kIsWeb;
  }
}
