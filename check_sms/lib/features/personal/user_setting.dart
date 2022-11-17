import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/widgets/button_text_widget.dart';
import 'package:check_sms/features/home/theme_setting.dart';
import 'package:check_sms/features/login/views/login.dart';
import 'package:check_sms/features/personal/bank_manage.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserSetting();
}

class _UserSetting extends State<UserSetting> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Alignment buttonTextAlignment = Alignment.centerLeft;
    return Column(
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
            '${UserInformationHelper.instance.getUserInformation().lastName} ${UserInformationHelper.instance.getUserInformation().middleName} ${UserInformationHelper.instance.getUserInformation().firstName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: width - 20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ButtonTextWidget(
                width: width,
                alignment: buttonTextAlignment,
                text: 'Chỉnh sửa thông tin cá nhân',
                textColor: DefaultTheme.BLUE_TEXT,
                function: () {},
              ),
              const Divider(
                color: DefaultTheme.GREY_LIGHT,
                height: 1,
              ),
              ButtonTextWidget(
                width: width,
                alignment: buttonTextAlignment,
                text: 'Quản lý tài khoản ngân hàng',
                textColor: DefaultTheme.BLUE_TEXT,
                function: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BankManageView()));
                },
              ),
              const Divider(
                color: DefaultTheme.GREY_LIGHT,
                height: 1,
              ),
              ButtonTextWidget(
                width: width,
                alignment: buttonTextAlignment,
                text: 'Kết nối với Telegram',
                textColor: DefaultTheme.BLUE_TEXT,
                function: () {},
              ),
              const Divider(
                color: DefaultTheme.GREY_LIGHT,
                height: 1,
              ),
              ButtonTextWidget(
                width: width,
                alignment: buttonTextAlignment,
                text: 'Thay đổi giao diện',
                textColor: DefaultTheme.BLUE_TEXT,
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
                  await UserInformationHelper.instance
                      .initialUserInformationHelper();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
