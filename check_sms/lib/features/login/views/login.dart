import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/textfield_widget.dart';
import 'package:check_sms/features/home/home.dart';
import 'package:check_sms/features/login/repositories/login_repository.dart';
import 'package:check_sms/models/account_login_dto.dart';
import 'package:check_sms/services/firestore/user_information_db.dart';
import 'package:check_sms/services/providers/page_select_provider.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  static final TextEditingController phoneNoController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            height: 150,
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                TextFieldWidget(
                  width: width,
                  isObscureText: false,
                  hintText: 'Số điện thoại',
                  controller: phoneNoController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.next,
                  onChange: (vavlue) {},
                ),
                const Divider(
                  height: 0.5,
                  color: DefaultTheme.GREY_LIGHT,
                ),
                TextFieldWidget(
                  width: width,
                  isObscureText: true,
                  hintText: 'Mật khẩu',
                  controller: passwordController,
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.done,
                  onChange: (vavlue) {},
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  width: width / 2 - 20,
                  text: 'Đăng nhập',
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.GREEN,
                  function: () async {
                    AccountLoginDTO dto = AccountLoginDTO(
                        phoneNo: phoneNoController.text,
                        password: passwordController.text);
                    LoginRepository loginRepository = const LoginRepository();
                    await loginRepository.login(dto).then(
                      (isLogin) async {
                        if (isLogin) {
                          Provider.of<PageSelectProvider>(context,
                                  listen: false)
                              .updateIndex(0);
                          await loginRepository.getUserInformation(
                              UserInformationHelper.instance.getUserId());
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                ButtonWidget(
                  width: width / 2 - 20,
                  text: 'Đăng ký',
                  textColor: DefaultTheme.GREEN,
                  bgColor: DefaultTheme.WHITE,
                  function: () {},
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}
