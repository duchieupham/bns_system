import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/features/home/home.dart';
import 'package:check_sms/features/login/blocs/login_bloc.dart';
import 'package:check_sms/features/login/views/login.dart';
import 'package:check_sms/features/personal/blocs/bank_manage_bloc.dart';
import 'package:check_sms/features/register/blocs/register_bloc.dart';
import 'package:check_sms/services/providers/bank_account_provider.dart';
import 'package:check_sms/services/providers/bank_select_provider.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:check_sms/services/providers/create_qr_provider.dart';
import 'package:check_sms/services/providers/page_select_provider.dart';
import 'package:check_sms/services/providers/register_provider.dart';
import 'package:check_sms/services/providers/theme_provider.dart';
import 'package:check_sms/services/shared_references/create_qr_helper.dart';
import 'package:check_sms/services/shared_references/theme_helper.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
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
  if (!sharedPrefs.containsKey('USER_ID') ||
      sharedPrefs.getString('USER_ID') == null) {
    await UserInformationHelper.instance.initialUserInformationHelper();
  }
}

class BNSApp extends StatelessWidget {
  const BNSApp({Key? key}) : super(key: key);

  static final _homeScreen = (UserInformationHelper.instance.getUserId() != '')
      ? const HomeScreen()
      : const Login();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BankManageBloc>(
            create: (BuildContext context) => BankManageBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<RegisterBloc>(
            create: (BuildContext context) => RegisterBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => PageSelectProvider()),
            ChangeNotifierProvider(
                create: (context) => CreateQRPageSelectProvider()),
            ChangeNotifierProvider(create: (context) => CreateQRProvider()),
            ChangeNotifierProvider(create: (context) => BankAccountProvider()),
            ChangeNotifierProvider(create: (context) => BankSelectProvider()),
            ChangeNotifierProvider(create: (context) => RegisterProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode:
                    (themeSelect.themeSystem == DefaultTheme.THEME_SYSTEM)
                        ? ThemeMode.system
                        : (themeSelect.themeSystem == DefaultTheme.THEME_LIGHT)
                            ? ThemeMode.light
                            : ThemeMode.dark,
                darkTheme: DefaultThemeData(context: context).darkTheme,
                theme: DefaultThemeData(context: context).lightTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  //  Locale('en'), // English
                  Locale('vi'), // Vietnamese
                ],
                home: _homeScreen,
              );
            },
          ),
        ),
      ),
    );
  }
}
