import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vierqr/commons/constants/configurations/firebase_config.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/features_mobile/log_sms/blocs/sms_bloc.dart';
import 'package:vierqr/features_mobile/log_sms/blocs/transaction_bloc.dart';
import 'package:vierqr/features_mobile/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features_mobile/login/blocs/login_bloc.dart';
import 'package:vierqr/features_mobile/login/views/login.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/blocs/member_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features_mobile/register/blocs/register_bloc.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/home_tab_provider.dart';
import 'package:vierqr/services/providers/memeber_manage_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/services/providers/pin_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/theme_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/create_qr_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/theme_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

//Share Preferences
late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await _initialServiceHelper();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseConfig.FIREBASE_STAGGING_OPTION,
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const VietQRApp());
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
  await EventBlocHelper.instance.initialEventBlocHelper();
}

class VietQRApp extends StatelessWidget {
  const VietQRApp({Key? key}) : super(key: key);

  static Widget _homeScreen = const Login();

  @override
  Widget build(BuildContext context) {
    _homeScreen = (UserInformationHelper.instance.getUserId() != '')
        ? const HomeScreen()
        : const Login();
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
          BlocProvider<UserEditBloc>(
            create: (BuildContext context) => UserEditBloc(),
          ),
          BlocProvider<MemberManageBloc>(
            create: (BuildContext context) => MemberManageBloc(),
          ),
          BlocProvider<SMSBloc>(
            create: (BuildContext context) => SMSBloc(),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc(),
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) => NotificationBloc(),
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
            ChangeNotifierProvider(create: (context) => PinProvider()),
            ChangeNotifierProvider(create: (context) => UserEditProvider()),
            ChangeNotifierProvider(create: (context) => HomeTabProvider()),
            ChangeNotifierProvider(create: (context) => ShortcutProvider()),
            ChangeNotifierProvider(
                create: (context) => SuggestionWidgetProvider()),
            ChangeNotifierProvider(
                create: (context) => MemeberManageProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeSelect, child) {
              return MaterialApp(
                builder: (context, child) {
                  //ignore system scale factor
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child ?? Container(),
                  );
                },
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
                home: Title(
                  title: 'VietQR',
                  color: DefaultTheme.BLACK,
                  child: _homeScreen,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
