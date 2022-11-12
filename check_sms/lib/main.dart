import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/features/home/home.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:check_sms/services/providers/page_select_provider.dart';
import 'package:check_sms/services/providers/theme_provider.dart';
import 'package:check_sms/services/shared_references/create_qr_helper.dart';
import 'package:check_sms/services/shared_references/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  runApp(const BNSApp());
}

Future<void> _initialServiceHelper() async {
  if (!sharedPrefs.containsKey('THEME_SYSTEM') ||
      sharedPrefs.getString('THEME_SYSTEM') == null) {
    await ThemeHelper.instance.initialTheme();
  }
  if (!sharedPrefs.containsKey('TRANSACTION_AMOUNT') ||
      sharedPrefs.getString('TRANSACTION_AMOUNT') == null) {
    await CreateQRHelper.instance.initialCreateQRHelper();
  }
}

class BNSApp extends StatelessWidget {
  const BNSApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => PageSelectProvider()),
          ChangeNotifierProvider(
              create: (context) => CreateQRPageSelectProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeSelect, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: (themeSelect.themeSystem == DefaultTheme.THEME_SYSTEM)
                  ? ThemeMode.system
                  : (themeSelect.themeSystem == DefaultTheme.THEME_LIGHT)
                      ? ThemeMode.light
                      : ThemeMode.dark,
              darkTheme: DefaultThemeData(context: context).darkTheme,
              theme: DefaultThemeData(context: context).lightTheme,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
