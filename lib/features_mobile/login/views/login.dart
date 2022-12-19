import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/features_mobile/login/blocs/login_bloc.dart';
import 'package:vierqr/features_mobile/login/events/login_event.dart';
import 'package:vierqr/features_mobile/login/frames/login_frame.dart';
import 'package:vierqr/features_mobile/login/repositories/login_repository.dart';
import 'package:vierqr/features_mobile/login/states/login_state.dart';
import 'package:vierqr/features_mobile/register/views/register_view.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
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

  static bool isInitial = false;

  static late LoginBloc _loginBloc;
  static String code = '';
  static const Uuid uuid = Uuid();

  const Login({Key? key}) : super(key: key);

  void initialServices(BuildContext context) {
    code = uuid.v1();
    _loginBloc = BlocProvider.of(context);
    _loginBloc.add(LoginEventInsertCode(code: code, loginBloc: _loginBloc));
    isInitial = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (!isInitial) {
      initialServices(context);
    }
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
            LoginRepository.codeLoginController.close();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (Route<dynamic> route) => true,
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
          widget1: _buildWidget1(
            context: context,
            width: width,
            isResized: ScreenResolutionUtils.instance.resizeWhen(width, 750),
          ),
          widget2: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BoxLayout(
                  width: 200,
                  height: 200,
                  borderRadius: 5,
                  enableShadow: true,
                  alignment: Alignment.center,
                  bgColor: DefaultTheme.WHITE,
                  padding: const EdgeInsets.all(0),
                  child: QrImage(
                    data: code,
                    size: 200,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-login.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(30, 30),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                const Text(
                  'Đăng nhập bằng QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                const SizedBox(
                  width: 250,
                  child: Text(
                    'Sử dụng ứng dụng VietQR trên điện thoại để quét mã đăng nhập.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildWidget1(
      {required BuildContext context,
      required bool isResized,
      required double width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/ic-viet-qr.png',
            width: 100,
            height: 100,
          ),
        ),
        BorderLayout(
          width: width,
          isError: false,
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
        const Padding(padding: EdgeInsets.only(top: 15)),
        const Text(
          'Quên mật khẩu?',
          style: TextStyle(
            color: DefaultTheme.GREEN,
            fontSize: 15,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        ButtonWidget(
          width: width,
          height: 40,
          text: 'Đăng nhập',
          borderRadius: 5,
          textColor: DefaultTheme.WHITE,
          bgColor: DefaultTheme.GREEN,
          function: () {
            openPinDialog(context);
          },
        ),
        (!isResized)
            ? const Padding(
                padding: EdgeInsets.only(top: 10),
              )
            : const SizedBox(),
        (!isResized)
            ? ButtonWidget(
                width: width,
                height: 40,
                text: 'Đăng nhập bằng QR Code',
                borderRadius: 5,
                textColor: Theme.of(context).hintColor,
                bgColor: Theme.of(context).canvasColor,
                function: () {
                  openPinDialog(context);
                },
              )
            : const SizedBox(),
        const Padding(padding: EdgeInsets.only(top: 15)),
        Row(
          children: [
            const Text(
              'Chưa có tài khoản?',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterView(
                      phoneNo: phoneNoController.text,
                    ),
                  ),
                );
              },
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  color: DefaultTheme.GREEN,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
