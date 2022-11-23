import 'dart:convert';

import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/dialog_widget.dart';
import 'package:check_sms/commons/widgets/textfield_widget.dart';
import 'package:check_sms/features/home/home.dart';
import 'package:check_sms/features/login/blocs/login_bloc.dart';
import 'package:check_sms/features/login/events/login_event.dart';
import 'package:check_sms/features/login/states/login_state.dart';
import 'package:check_sms/features/register/views/register_view.dart';
import 'package:check_sms/models/account_login_dto.dart';
import 'package:check_sms/services/providers/page_select_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  static final TextEditingController phoneNoController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  static late LoginBloc _loginBloc;

  const Login({Key? key}) : super(key: key);

  void initialServices(BuildContext context) {
    _loginBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocListener<LoginBloc, LoginState>(
        listener: ((context, state) {
          if (state is LoginLoadingState) {
            DialogWidget.instance.openLoadingDialog(context);
          }
          if (state is LoginSuccessfulState) {
            _loginBloc.add(LoginEventGetUserInformation(userId: state.userId));
          }
          if (state is LoginGetUserInformationSuccessfulState) {
            //pop loading dialog
            Navigator.pop(context);
            //update index 0 of dashboard
            Provider.of<PageSelectProvider>(context, listen: false)
                .updateIndex(0);
            //navigate to home screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
          if (state is LoginFailedState) {
            //pop loading dialog

            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              //in case pop keyboard
              Navigator.pop(context);
            }
            //show msg dialog
            DialogWidget.instance.openMsgDialog(context,
                'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.');
          }
        }),
        child: Column(
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
                    function: () {
                      List<int> key = utf8.encode(phoneNoController.text);
                      List<int> passwordData =
                          utf8.encode(passwordController.text);
                      Hmac hmacSHA256 = Hmac(sha256, key);
                      Digest passwordEncrypted =
                          hmacSHA256.convert(passwordData);
                      AccountLoginDTO dto = AccountLoginDTO(
                          phoneNo: phoneNoController.text,
                          password: passwordEncrypted.toString());
                      _loginBloc.add(LoginEventByPhone(dto: dto));
                    },
                  ),
                  ButtonWidget(
                    width: width / 2 - 20,
                    text: 'Đăng ký',
                    textColor: DefaultTheme.GREEN,
                    bgColor: Theme.of(context).buttonColor,
                    function: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const RegisterView()),
                      );
                    },
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}
