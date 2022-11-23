import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConsrtructor();

  static const ThemeHelper _instance = ThemeHelper._privateConsrtructor();
  static ThemeHelper get instance => _instance;
  //
  Future<void> initialTheme() async {
    await sharedPrefs.setString('THEME_SYSTEM', DefaultTheme.THEME_SYSTEM);
  }

  Future<void> updateTheme(String theme) async {
    await sharedPrefs.setString('THEME_SYSTEM', theme);
  }

  String getTheme() {
    if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
        sharedPrefs.getString('THEME_SYSTEM') == null) {
      initialTheme();
    }
    return sharedPrefs.getString('THEME_SYSTEM')!;
  }
}
