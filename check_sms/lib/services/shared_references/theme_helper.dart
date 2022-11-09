import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConsrtructor();

  static const ThemeHelper _instance = ThemeHelper._privateConsrtructor();
  static ThemeHelper get instance => _instance;
  //
  void initialTheme() {
    sharedPrefs.setString('THEME_SYSTEM', DefaultTheme.THEME_SYSTEM);
  }

  void updateTheme(String theme) {
    if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
        sharedPrefs.getString('THEME_SYSTEM') == null) {
      initialTheme();
    }
    sharedPrefs.setString('THEME_SYSTEM', theme);
  }

  String getTheme() {
    if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
        sharedPrefs.getString('THEME_SYSTEM') == null) {
      initialTheme();
    }
    return sharedPrefs.getString('THEME_SYSTEM')!;
  }
}
