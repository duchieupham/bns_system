import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:check_sms/commons/utils/string_utils.dart';
import 'package:check_sms/commons/utils/time_utils.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/checkbox_widget.dart';
import 'package:check_sms/commons/widgets/dialog_widget.dart';
import 'package:check_sms/commons/widgets/sub_header_widget.dart';
import 'package:check_sms/commons/widgets/textfield_widget.dart';
import 'package:check_sms/features/register/blocs/register_bloc.dart';
import 'package:check_sms/features/register/events/register_event.dart';
import 'package:check_sms/features/register/states/register_state.dart';
import 'package:check_sms/models/account_register_dto.dart';
import 'package:check_sms/services/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  static final TextEditingController _phoneNoController =
      TextEditingController();

  static final TextEditingController _passwordController =
      TextEditingController();

  static final TextEditingController _confirmPassController =
      TextEditingController();
  static final TextEditingController _firstNameController =
      TextEditingController();

  static final TextEditingController _middleNameController =
      TextEditingController();

  static final TextEditingController _lastNameController =
      TextEditingController();

  static final TextEditingController _bankAccountController =
      TextEditingController();

  static final TextEditingController _bankAccountNameController =
      TextEditingController();

  static final TextEditingController _addressController =
      TextEditingController();

  static final List<String> _banks = [];
  static String _bankSelected = '';
  static late RegisterBloc _registerBloc;

  void initialServices(BuildContext context) {
    _registerBloc = BlocProvider.of(context);
    if (_banks.isEmpty) {
      _banks.addAll(Provider.of<RegisterProvider>(context, listen: false)
          .getListAvailableBank());
      _bankSelected = _banks.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Đăng ký'),
          Expanded(
            child: BlocListener<RegisterBloc, RegisterState>(
              listener: ((context, state) {
                if (state is RegisterLoadingState) {
                  DialogWidget.instance.openLoadingDialog(context);
                }
                if (state is RegisterFailedState) {
                  //pop loading dialog
                  Navigator.pop(context);
                  //
                  DialogWidget.instance.openMsgDialog(context,
                      'Đăng ký thất bại, vui lòng kiểm tra lại kết nối mạng.');
                }
                if (state is RegisterSuccessState) {
                  //pop loading dialog
                  Navigator.pop(context);
                  //pop to login page
                  Navigator.pop(context);
                }
              }),
              child: Consumer<RegisterProvider>(
                builder: (context, value, child) {
                  return ListView(
                    children: [
                      _buildTitle(
                        'Thông tin đăng nhập',
                        width,
                        true,
                      ),
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
                              controller: _phoneNoController,
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
                              hintText: 'Mật khẩu (8-30 ký tự, gồm chữ và số)',
                              controller: _passwordController,
                              inputType: TextInputType.text,
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
                              hintText: 'Xác nhận lại mật khẩu',
                              controller: _confirmPassController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: value.phoneErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Số điện thoại phải đúng định dạng.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: value.passwordErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Mật khẩu từ 8 đến 30 ký tự, bao gồm cả chữ và số.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: value.confirmPassErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Xác nhận mật khẩu không trùng khớp.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      _buildTitle(
                        'Thông tin cá nhân',
                        width,
                        true,
                      ),
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
                              hintText: 'Họ',
                              controller: _lastNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                            const Divider(
                              height: 0.5,
                              color: DefaultTheme.GREY_LIGHT,
                            ),
                            TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              hintText: 'Tên đệm',
                              controller: _middleNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                            const Divider(
                              height: 0.5,
                              color: DefaultTheme.GREY_LIGHT,
                            ),
                            TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              hintText: 'Tên',
                              controller: _firstNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: value.lastNameErr || value.firstNameErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Họ - Tên không được để trống.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Container(
                        width: width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Ngày sinh',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await DialogWidget.instance
                                      .openDateTimePickerDialog(
                                    context,
                                    'Ngày sinh',
                                    (time) {
                                      value.updateBirthDate(
                                        TimeUtils.instance.formatDate(
                                          time.toString(),
                                        ),
                                      );
                                    },
                                  ).then((_) {
                                    if (value.birthDate == '01/01/1970') {
                                      value.updateBirthDate(
                                        TimeUtils.instance.formatDate(
                                          DateTime.now().toString(),
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Text(
                                  value.birthDate,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Container(
                        width: width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Giới tính',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Nam',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            CheckBoxWidget(
                              check: (value.gender),
                              size: 20,
                              function: () {
                                value.updateGender(true);
                              },
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            const Text(
                              'Nữ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            CheckBoxWidget(
                              check: (!value.gender),
                              size: 20,
                              function: () {
                                value.updateGender(false);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      _buildTitle(
                        'Thông tin tài khoản ngân hàng',
                        width,
                        true,
                      ),
                      Container(
                        width: width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: width,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              // alignment: Alignment.centerLeft,
                              child: DropdownButton<String>(
                                value: _bankSelected,
                                icon: Image.asset(
                                  'assets/images/ic-dropdown.png',
                                  width: 30,
                                  height: 30,
                                ),
                                elevation: 0,
                                style: const TextStyle(fontSize: 15),
                                underline: const SizedBox(
                                  height: 0,
                                ),
                                onChanged: (String? selected) {
                                  if (selected == null) {
                                    _bankSelected = _banks.first;
                                    //    value.updateBankSelected(banks.first);
                                  } else {
                                    _bankSelected = selected;
                                    value.updateBankSelected(selected);
                                  }
                                },
                                items: _banks.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                      width: width - 120,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const Divider(
                              height: 0.5,
                              color: DefaultTheme.GREY_LIGHT,
                            ),
                            TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              hintText: 'Số tài khoản',
                              controller: _bankAccountController,
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
                              isObscureText: false,
                              hintText: 'Tên tài khoản',
                              controller: _bankAccountNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {},
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: value.bankSelectedErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Vui lòng chọn ngân hàng.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: value.bankAccountErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Số tài khoản phải đúng định dạng.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: value.bankAccountNameErr,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30, top: 5, right: 30),
                          child: Text(
                            'Tên tài khoản không được để trống.',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      _buildTitle(
                        'Địa chỉ',
                        width,
                        false,
                      ),
                      Container(
                        width: width,
                        height: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          maxLines: 10,
                          controller: _addressController,
                          textInputAction: TextInputAction.done,
                          maxLength: 1000,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Địa chỉ tối đa 1000 ký tự.',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          'Các mục gắn dấu (*) là bắt buộc.\nThông tin tài khoản ngân hàng yêu cầu chính xác.',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 50)),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: ButtonWidget(
                width: width - 40,
                text: 'Đăng ký tài khoản',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  Provider.of<RegisterProvider>(context, listen: false)
                      .updateErrs(
                    phoneErr: !StringUtils.instance
                        .isNumeric(_phoneNoController.text),
                    passErr: !StringUtils.instance
                        .isValidPassword(_passwordController.text),
                    confirmPassErr: !StringUtils.instance.isValidConfirmText(
                        _passwordController.text, _confirmPassController.text),
                    firstNameErr: _firstNameController.text.isEmpty,
                    lastNameErr: _lastNameController.text.isEmpty,
                    bankSelectedErr: _bankSelected == 'Chọn ngân hàng',
                    bankAccountErr: !StringUtils.instance
                        .isNumeric(_bankAccountController.text),
                    bankAccountNameErr: _bankAccountNameController.text.isEmpty,
                  );
                  if (Provider.of<RegisterProvider>(context, listen: false)
                      .isValidValidation()) {
                    final Uuid uuid = Uuid();

                    AccountRegisterDTO dto = AccountRegisterDTO(
                      userId: uuid.v1(),
                      firstName: _firstNameController.text,
                      middleName: _middleNameController.text,
                      lastName: _lastNameController.text,
                      birthdate:
                          Provider.of<RegisterProvider>(context, listen: false)
                              .birthDate,
                      gender:
                          Provider.of<RegisterProvider>(context, listen: false)
                              .gender,
                      phoneNo: _phoneNoController.text,
                      address: _addressController.text,
                      password: _passwordController.text,
                      bankAccount: _bankAccountController.text,
                      bankAccountName: _bankAccountNameController.text,
                      bankCode:
                          Provider.of<RegisterProvider>(context, listen: false)
                              .bankSelected
                              .split('-')[0]
                              .trim(),
                      bankName:
                          BankInformationUtil.instance.getBankNameFromSelectBox(
                        Provider.of<RegisterProvider>(context, listen: false)
                            .bankSelected,
                      ),
                    );
                    _registerBloc.add(RegisterEventSubmit(dto: dto));
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String text, double width, bool isRequired) {
    return Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Visibility(
              visible: isRequired,
              child: const Text(
                '*',
                style: TextStyle(
                  color: DefaultTheme.RED_TEXT,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }
}
