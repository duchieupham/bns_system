import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/features_mobile/login/blocs/login_bloc.dart';
import 'package:vierqr/features_mobile/login/events/login_event.dart';
import 'package:vierqr/features_mobile/login/frames/login_frame.dart';
import 'package:vierqr/features_mobile/login/states/login_state.dart';
import 'package:vierqr/features_mobile/register/views/register_view.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
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
    double height = MediaQuery.of(context).size.height;
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
            DialogWidget.instance.openMsgDialog(
              context: context,
              title: 'Đăng nhập không thành công',
              msg:
                  'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
            );
          }
        }),
        child: LoginFrame(
          width: width,
          height: height,
          mobileChildren: [
            SizedBox(
              width: width * 0.5,
              height: 150,
              child: Image.asset(
                'assets/images/ic-viet-qr.png',
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
                    autoFocus: true,
                    hintText: 'Số điện thoại',
                    controller: phoneNoController,
                    inputType: TextInputType.number,
                    keyboardAction: TextInputAction.next,
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
                      openPinDialog(context);
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
                          builder: (context) => RegisterView(
                            phoneNo: phoneNoController.text,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
          ],
          webChildren: [
            Image.asset(
              'assets/images/ic-viet-qr.png',
              width: width * 0.15,
              height: 200,
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFieldWidget(
                width: width,
                isObscureText: false,
                autoFocus: true,
                hintText: 'Số điện thoại',
                controller: phoneNoController,
                inputType: TextInputType.number,
                keyboardAction: TextInputAction.next,
                onChange: (vavlue) {},
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 50)),
            ButtonWidget(
              width: width,
              text: 'Đăng nhập',
              textColor: DefaultTheme.WHITE,
              bgColor: DefaultTheme.GREEN,
              function: () {
                openPinDialog(context);
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            ButtonWidget(
              width: width,
              text: 'Đăng ký',
              textColor: DefaultTheme.GREEN,
              bgColor: Theme.of(context).canvasColor,
              function: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterView(
                      phoneNo: phoneNoController.text,
                    ),
                  ),
                );
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }

  void openPinDialog(BuildContext context) {
    if (phoneNoController.text.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          context: context,
          title: 'Đăng nhập không thành công',
          msg: 'Vui lòng nhập số điện thoại để đăng nhập.');
    } else {
      DialogWidget.instance.openPINDialog(
          context: context,
          title: 'Nhập mã PIN',
          onDone: (pin) {
            Navigator.pop(context);
            AccountLoginDTO dto = AccountLoginDTO(
                phoneNo: phoneNoController.text,
                password: EncryptUtils.instance.encrypted(
                  phoneNoController.text,
                  pin,
                ));
            _loginBloc.add(
              LoginEventByPhone(dto: dto),
            );
          });
    }
  }
}
