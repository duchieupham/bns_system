import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_text_widget.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/features_mobile/home/theme_setting.dart';
import 'package:vierqr/features_mobile/log_sms/repositories/sms_repository.dart';
import 'package:vierqr/features_mobile/login/blocs/login_bloc.dart';
import 'package:vierqr/features_mobile/login/events/login_event.dart';
import 'package:vierqr/features_mobile/login/views/login.dart';
import 'package:vierqr/features_mobile/personal/views/bank_manage.dart';
import 'package:vierqr/features_mobile/personal/views/qr_scanner.dart';
import 'package:vierqr/features_mobile/personal/views/user_edit_view.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserSetting();
}

class _UserSetting extends State<UserSetting> {
  static late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Alignment buttonTextAlignment = Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/images/ic-avatar.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
            ),
            child: Text(
              UserInformationHelper.instance.getUserFullname(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: width - 40,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Chỉnh sửa thông tin cá nhân',
                  textColor: DefaultTheme.GREEN,
                  function: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserEditView(),
                      ),
                    );
                  },
                ),
                const Divider(
                  color: DefaultTheme.GREY_LIGHT,
                  height: 1,
                ),
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Quản lý tài khoản ngân hàng',
                  textColor: DefaultTheme.GREEN,
                  function: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BankManageView(),
                      ),
                    );
                  },
                ),
                const Divider(
                  color: DefaultTheme.GREY_LIGHT,
                  height: 1,
                ),
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Đăng nhập bằng mã QR',
                  textColor: DefaultTheme.GREEN,
                  function: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => QRScanner(),
                      ),
                    )
                        .then((code) {
                      if (code != null) {
                        if (code.toString().isNotEmpty) {
                          _loginBloc.add(
                            LoginEventUpdateCode(
                              code: code,
                              userId:
                                  UserInformationHelper.instance.getUserId(),
                            ),
                          );
                        }
                      }
                    });
                  },
                ),
                const Divider(
                  color: DefaultTheme.GREY_LIGHT,
                  height: 1,
                ),
                // ButtonTextWidget(
                //   width: width,
                //   alignment: buttonTextAlignment,
                //   text: 'Kết nối với Telegram',
                //   textColor: DefaultTheme.GREEN,
                //   function: () {},
                // ),
                // const Divider(
                //   color: DefaultTheme.GREY_LIGHT,
                //   height: 1,
                // ),
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Thay đổi giao diện',
                  textColor: DefaultTheme.GREEN,
                  function: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ThemeSettingView()));
                  },
                ),
                const Divider(
                  color: DefaultTheme.GREY_LIGHT,
                  height: 1,
                ),
                ButtonTextWidget(
                  width: width,
                  alignment: buttonTextAlignment,
                  text: 'Đăng xuất',
                  textColor: DefaultTheme.RED_TEXT,
                  function: () async {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    await resetAll(context).then((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const VietQRApp()),
                          (Route<dynamic> route) => false);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> resetAll(BuildContext context) async {
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
    Provider.of<BankAccountProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<RegisterProvider>(context, listen: false).reset();
    await EventBlocHelper.instance.initialEventBlocHelper();
    await UserInformationHelper.instance.initialUserInformationHelper();
  }
}
