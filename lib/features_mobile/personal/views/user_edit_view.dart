import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_mweb_widget_old.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_web_widget_old.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/features_mobile/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/user_edit_event.dart';
import 'package:vierqr/features_mobile/personal/frames/user_edit_frame.dart';
import 'package:vierqr/features_mobile/personal/states/user_edit_state.dart';
import 'package:vierqr/features_mobile/personal/views/qr_scanner.dart';
import 'package:vierqr/features_mobile/personal/views/user_update_password_view.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/user_information_dto.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class UserEditView extends StatelessWidget {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  static String _birthDate = '';
  static late UserEditBloc _userEditBloc;

  UserEditView({super.key});

  void initialServices(BuildContext context) {
    if (!Provider.of<UserEditProvider>(context, listen: false)
        .availableUpdate) {
      _userEditBloc = BlocProvider.of(context);
      final UserInformationDTO userInformationDTO =
          UserInformationHelper.instance.getUserInformation();
      _lastNameController.value =
          _lastNameController.value.copyWith(text: userInformationDTO.lastName);
      _middleNameController.value = _middleNameController.value
          .copyWith(text: userInformationDTO.middleName);
      _firstNameController.value = _firstNameController.value
          .copyWith(text: userInformationDTO.firstName);
      _birthDate = userInformationDTO.birthDate;
      _addressController.value =
          _addressController.value.copyWith(text: userInformationDTO.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          (PlatformUtils.instance.resizeWhen(width, 800))
              ? HeaderWebWidgetOld(
                  title: 'Thông tin cá nhân',
                  isSubHeader: true,
                  functionBack: () {
                    backToPreviousPage(context);
                  },
                  functionHome: () {
                    backToHome(context);
                  },
                )
              : (PlatformUtils.instance.isWeb())
                  ? HeaderMwebWidgetOld(
                      title: 'Thông tin cá nhân',
                      isSubHeader: true,
                      functionBack: () {
                        backToPreviousPage(context);
                      },
                      functionHome: () {
                        backToHome(context);
                      },
                    )
                  : SubHeader(
                      title: 'Thông tin cá nhân',
                      function: () {
                        backToPreviousPage(context);
                      }),
          Expanded(
            child: BlocListener<UserEditBloc, UserEditState>(
              listener: ((context, state) {
                if (state is UserEditLoadingState) {
                  DialogWidget.instance.openLoadingDialog(context);
                }
                if (state is UserEditFailedState) {
                  //pop loading dialog
                  Navigator.pop(context);
                  //
                  DialogWidget.instance.openMsgDialog(
                      context: context,
                      title: 'Không thể cập nhật thông tin',
                      msg:
                          'Cập nhật thông tin thất bại. Vui lòng kiểm tra lại kết nối mạng.');
                }
                if (state is UserEditSuccessfulState) {
                  //pop loading dialog
                  Navigator.pop(context);
                  //
                  Provider.of<UserEditProvider>(context, listen: false).reset();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false);
                }
                if (state is UserEditPasswordFailedState) {
                  if (PlatformUtils.instance.isWeb()) {
                    //pop loading dialog
                    Navigator.pop(context);
                    if (Navigator.canPop(context)) {
                      //in case pop keyboard
                      Navigator.pop(context);
                    }
                    //
                    DialogWidget.instance.openMsgDialog(
                      context: context,
                      title: 'Không thể cập nhật mã PIN',
                      msg: state.msg,
                    );
                  }
                }
                if (state is UserEditPasswordSuccessfulState) {
                  if (PlatformUtils.instance.isWeb()) {
                    //pop loading dialog
                    Navigator.pop(context);
                    //
                    Provider.of<UserEditProvider>(context, listen: false)
                        .resetPasswordErr();
                    Navigator.pop(context);
                  }
                }
              }),
              child: Consumer<UserEditProvider>(
                builder: (context, provider, child) {
                  return UserEditFrame(
                    width: width,
                    height: height,
                    mobileChildren: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        BoxLayout(
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child:
                                    Image.asset('assets/images/ic-avatar.png'),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 5)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      UserInformationHelper.instance
                                          .getUserFullname(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      UserInformationHelper.instance
                                          .getUserInformation()
                                          .phoneNo,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: DefaultTheme.GREY_TEXT,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Padding(padding: EdgeInsets.only(top: 10)),
                        // ButtonWidget(
                        //   width: width - 40,
                        //   text: 'Cập nhật ảnh đại diện',
                        //   textColor: DefaultTheme.GREEN,
                        //   bgColor: Theme.of(context).cardColor,
                        //   function: () {},
                        // ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        ButtonWidget(
                          width: width - 40,
                          text: 'Đổi mã PIN',
                          textColor: DefaultTheme.GREEN,
                          bgColor: Theme.of(context).cardColor,
                          function: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UserUpdatePassword(),
                              ),
                            );
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        ButtonWidget(
                          width: width - 40,
                          text: 'Cập nhật thông tin qua CCCD',
                          textColor: DefaultTheme.GREEN,
                          bgColor: Theme.of(context).cardColor,
                          function: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => QRScanner(),
                              ),
                            )
                                .then((code) {
                              if (code != '' &&
                                  code.toString().split('|').length == 7) {
                                List<String> informations =
                                    code.toString().split('|');
                                String fullName = informations[2];
                                String firstName = fullName.split(' ').last;
                                String lastName = fullName.split(' ').first;
                                String middleName = '';
                                for (int i = 0;
                                    i < fullName.split(' ').length;
                                    i++) {
                                  if (i != 0 &&
                                      i != fullName.split(' ').length - 1) {
                                    middleName +=
                                        ' ${fullName.split(' ')[i]}'.trim();
                                  }
                                }
                                String birthdate = informations[3];
                                String bdDay = birthdate.substring(0, 2);
                                String bdMonth = birthdate.substring(2, 4);
                                String bdYear = birthdate.substring(4, 8);
                                bool gender = informations[4] == 'Nam';
                                String address = informations[5];
                                //
                                _lastNameController.value = _lastNameController
                                    .value
                                    .copyWith(text: lastName);
                                _middleNameController.value =
                                    _middleNameController.value
                                        .copyWith(text: middleName);
                                _firstNameController.value =
                                    _firstNameController.value
                                        .copyWith(text: firstName);
                                _birthDate = '$bdDay/$bdMonth/$bdYear';

                                _addressController.value = _addressController
                                    .value
                                    .copyWith(text: address);
                                provider.updateGender(gender);
                                provider.setAvailableUpdate(true);
                              } else {
                                // DialogWidget.instance.openMsgDialog(
                                //   context: context,
                                //   title: 'Không thể cập nhật',
                                //   msg:
                                //       'Mã QR không đúng định dạng, vui lòng thử lại.',
                                // );
                              }
                            });
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        ButtonWidget(
                          width: width - 40,
                          text: 'Xoá tài khoản',
                          textColor: DefaultTheme.RED_TEXT,
                          bgColor: Theme.of(context).cardColor,
                          function: () {
                            //
                          },
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        BoxLayout(
                          width: width,
                          child: Column(
                            children: [
                              TextFieldWidget(
                                width: width,
                                textfieldType: TextfieldType.LABEL,
                                isObscureText: false,
                                title: 'Họ',
                                hintText: '',
                                controller: _lastNameController,
                                inputType: TextInputType.text,
                                keyboardAction: TextInputAction.next,
                                onChange: (vavlue) {
                                  provider.setAvailableUpdate(true);
                                },
                              ),
                              DividerWidget(width: width),
                              TextFieldWidget(
                                width: width,
                                textfieldType: TextfieldType.LABEL,
                                isObscureText: false,
                                title: 'Tên đệm',
                                hintText: '',
                                controller: _middleNameController,
                                inputType: TextInputType.text,
                                keyboardAction: TextInputAction.next,
                                onChange: (vavlue) {
                                  provider.setAvailableUpdate(true);
                                },
                              ),
                              DividerWidget(width: width),
                              TextFieldWidget(
                                width: width,
                                textfieldType: TextfieldType.LABEL,
                                isObscureText: false,
                                title: 'Tên',
                                hintText: '',
                                controller: _firstNameController,
                                inputType: TextInputType.text,
                                keyboardAction: TextInputAction.next,
                                onChange: (vavlue) {
                                  provider.setAvailableUpdate(true);
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: provider.firstNameErr,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              'Tên không được bỏ trống.',
                              style: TextStyle(
                                color: DefaultTheme.RED_TEXT,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        BoxLayout(
                          width: width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  'Ngày sinh',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 150,
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                      textTheme: CupertinoTextThemeData(
                                        dateTimePickerTextStyle: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    child: CupertinoDatePicker(
                                      initialDateTime: TimeUtils.instance
                                          .getDateFromString(_birthDate),
                                      maximumDate: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: ((time) {
                                        provider.setAvailableUpdate(true);
                                        _birthDate = TimeUtils.instance
                                            .formatDate(time.toString());
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        BoxLayout(
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 5)),
                              CheckBoxWidget(
                                check: (provider.gender),
                                size: 20,
                                function: () {
                                  provider.setAvailableUpdate(true);
                                  provider.updateGender(true);
                                },
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              const Text(
                                'Nữ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 5)),
                              CheckBoxWidget(
                                check: (!provider.gender),
                                size: 20,
                                function: () {
                                  provider.setAvailableUpdate(true);
                                  provider.updateGender(false);
                                },
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        BoxLayout(
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Địa chỉ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 100,
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
                                    onChanged: (value) {
                                      provider.setAvailableUpdate(true);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                      ],
                    ),
                    widget1: SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                              'assets/images/ic-avatar.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              UserInformationHelper.instance.getUserFullname(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              UserInformationHelper.instance
                                  .getUserInformation()
                                  .phoneNo,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: 200,
                            height: 30,
                            borderRadius: 5,
                            text: 'Cập nhật ảnh đại diện',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {},
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: 200,
                            height: 30,
                            borderRadius: 5,
                            text: 'Đổi mã PIN',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {
                              _openChangePIN(context);
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ButtonWidget(
                            width: 200,
                            height: 30,
                            borderRadius: 5,
                            text: 'Cập nhật thông tin qua CCCD',
                            textColor: DefaultTheme.GREEN,
                            bgColor: Theme.of(context).cardColor,
                            function: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => QRScanner(),
                                ),
                              )
                                  .then((code) {
                                if (code != '' &&
                                    code.toString().split('|').length == 7) {
                                  List<String> informations =
                                      code.toString().split('|');
                                  String fullName = informations[2];
                                  String firstName = fullName.split(' ').last;
                                  String lastName = fullName.split(' ').first;
                                  String middleName = '';
                                  for (int i = 0;
                                      i < fullName.split(' ').length;
                                      i++) {
                                    if (i != 0 &&
                                        i != fullName.split(' ').length - 1) {
                                      middleName +=
                                          ' ${fullName.split(' ')[i]}'.trim();
                                    }
                                  }
                                  String birthdate = informations[3];
                                  String bdDay = birthdate.substring(0, 2);
                                  String bdMonth = birthdate.substring(2, 4);
                                  String bdYear = birthdate.substring(4, 8);
                                  bool gender = informations[4] == 'Nam';
                                  String address = informations[5];
                                  //
                                  _lastNameController.value =
                                      _lastNameController.value
                                          .copyWith(text: lastName);
                                  _middleNameController.value =
                                      _middleNameController.value
                                          .copyWith(text: middleName);
                                  _firstNameController.value =
                                      _firstNameController.value
                                          .copyWith(text: firstName);
                                  _birthDate = '$bdDay/$bdMonth/$bdYear';

                                  _addressController.value = _addressController
                                      .value
                                      .copyWith(text: address);
                                  provider.updateGender(gender);
                                  provider.setAvailableUpdate(true);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    widget2: BoxLayout(
                      width: 500,
                      borderRadius: 0,
                      child: Column(
                        children: [
                          _buildTitle('Họ'),
                          BorderLayout(
                            width: 500,
                            isError: false,
                            child: TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              title: 'Họ',
                              hintText: '',
                              controller: _lastNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {
                                provider.setAvailableUpdate(true);
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Tên đệm'),
                          BorderLayout(
                            width: 500,
                            isError: false,
                            child: TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              title: 'Tên đệm',
                              hintText: '',
                              controller: _middleNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {
                                provider.setAvailableUpdate(true);
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Tên'),
                          BorderLayout(
                            width: 500,
                            isError: false,
                            child: TextFieldWidget(
                              width: width,
                              isObscureText: false,
                              title: 'Tên',
                              hintText: '',
                              controller: _firstNameController,
                              inputType: TextInputType.text,
                              keyboardAction: TextInputAction.next,
                              onChange: (vavlue) {
                                provider.setAvailableUpdate(true);
                              },
                            ),
                          ),
                          Visibility(
                            visible: provider.firstNameErr,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                  'Tên không được bỏ trống.',
                                  style: TextStyle(
                                    color: DefaultTheme.RED_TEXT,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Giới tính'),
                          BorderLayout(
                            width: 500,
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            isError: false,
                            child: Row(
                              children: [
                                const Text(
                                  'Nam',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 5)),
                                CheckBoxWidget(
                                  check: (provider.gender),
                                  size: 20,
                                  function: () {
                                    provider.setAvailableUpdate(true);
                                    provider.updateGender(true);
                                  },
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                const Text(
                                  'Nữ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 5)),
                                CheckBoxWidget(
                                  check: (!provider.gender),
                                  size: 20,
                                  function: () {
                                    provider.setAvailableUpdate(true);
                                    provider.updateGender(false);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Ngày sinh'),
                          BorderLayout(
                            width: 500,
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            isError: false,
                            child: InkWell(
                              onTap: () async {
                                await _openDatePicker(context);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _birthDate,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          _buildTitle('Địa chỉ'),
                          BorderLayout(
                            width: 500,
                            height: 150,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            isError: false,
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
                              onChanged: (value) {
                                provider.setAvailableUpdate(true);
                              },
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Consumer<UserEditProvider>(
                            builder: (context, provider, child) {
                              return Visibility(
                                visible: provider.availableUpdate,
                                child: ButtonWidget(
                                  width: 500,
                                  text: 'Cập nhật',
                                  textColor: DefaultTheme.WHITE,
                                  bgColor: DefaultTheme.GREEN,
                                  function: () {
                                    provider.updateErrors(
                                        _firstNameController.text.isEmpty);
                                    if (provider.isValidUpdate()) {
                                      UserInformationDTO userInformationDTO =
                                          UserInformationDTO(
                                        userId: UserInformationHelper.instance
                                            .getUserId(),
                                        firstName: _firstNameController.text,
                                        middleName: _middleNameController.text,
                                        lastName: _lastNameController.text,
                                        birthDate: _birthDate,
                                        gender: '${provider.gender}',
                                        phoneNo: UserInformationHelper.instance
                                            .getUserInformation()
                                            .phoneNo,
                                        address: _addressController.text,
                                      );
                                      _userEditBloc.add(
                                          UserEditInformationEvent(
                                              userInformationDTO:
                                                  userInformationDTO));
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          (PlatformUtils.instance.isWeb())
              ? const Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    top: 10,
                  ),
                  child: Consumer<UserEditProvider>(
                    builder: (context, provider, child) {
                      return Visibility(
                        visible: provider.availableUpdate,
                        child: ButtonWidget(
                          width: width - 40,
                          text: 'Cập nhật',
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          function: () {
                            provider.updateErrors(
                                _firstNameController.text.isEmpty);
                            if (provider.isValidUpdate()) {
                              UserInformationDTO userInformationDTO =
                                  UserInformationDTO(
                                userId:
                                    UserInformationHelper.instance.getUserId(),
                                firstName: _firstNameController.text,
                                middleName: _middleNameController.text,
                                lastName: _lastNameController.text,
                                birthDate: _birthDate,
                                gender: '${provider.gender}',
                                phoneNo: UserInformationHelper.instance
                                    .getUserInformation()
                                    .phoneNo,
                                address: _addressController.text,
                              );
                              _userEditBloc.add(UserEditInformationEvent(
                                  userInformationDTO: userInformationDTO));
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _openDatePicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: TimeUtils.instance.getDateFromString(_birthDate),
      firstDate: TimeUtils.instance.getDateFromString('01/01/1900'),
      lastDate: DateTime.now(),
      helpText: 'Ngày sinh',
      cancelText: 'Đóng',
      confirmText: 'Chọn',
    ).then((pickedDate) {
      if (pickedDate != null) {
        Provider.of<UserEditProvider>(context, listen: false)
            .setAvailableUpdate(true);
        _birthDate = TimeUtils.instance.formatDate(pickedDate.toString());
      }
    });
  }

  _openChangePIN(BuildContext context) {
    final TextEditingController _oldPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPassController =
        TextEditingController();
    double width = 500;
    return DialogWidget.instance.openContentDialog(
      context,
      () {
        Provider.of<UserEditProvider>(context, listen: false)
            .resetPasswordErr();
        Navigator.pop(context);
      },
      Consumer<UserEditProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Đổi mã PIN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTitle('Mã PIN cũ'),
                      BorderLayout(
                        width: width,
                        isError: provider.oldPassErr,
                        child: TextFieldWidget(
                          width: width,
                          isObscureText: true,
                          title: 'Mã PIN cũ',
                          titleWidth: 120,
                          hintText: 'Mã PIN hiện tại',
                          controller: _oldPasswordController,
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: (vavlue) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.oldPassErr,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Mã PIN cũ không đúng định dạng.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      _buildTitle('Mã PIN mới'),
                      BorderLayout(
                        width: width,
                        isError: provider.newPassErr,
                        child: TextFieldWidget(
                          width: width,
                          isObscureText: true,
                          title: 'Mã PIN mới',
                          titleWidth: 120,
                          hintText: 'Bao gồm 6 số',
                          controller: _newPasswordController,
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: (vavlue) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.newPassErr,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Mã PIN mới bao gồm 6 số.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      _buildTitle('Xác nhận lại'),
                      BorderLayout(
                        width: width,
                        isError: provider.confirmPassErr,
                        child: TextFieldWidget(
                          width: width,
                          isObscureText: true,
                          title: 'Xác nhận lại',
                          titleWidth: 120,
                          hintText: 'Xác nhận lại mã PIN mới',
                          controller: _confirmPassController,
                          inputType: TextInputType.number,
                          keyboardAction: TextInputAction.next,
                          onChange: (vavlue) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.confirmPassErr,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 30),
                            child: Text(
                              'Xác nhận mã PIN không trùng khớp.',
                              style: TextStyle(
                                  color: DefaultTheme.RED_TEXT, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
              ),
              ButtonWidget(
                width: width - 40,
                text: 'Cập nhật',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  Provider.of<UserEditProvider>(context, listen: false)
                      .updatePasswordErrs(
                    (_oldPasswordController.text.isEmpty ||
                        _oldPasswordController.text.length != 6),
                    (_newPasswordController.text.isEmpty ||
                        _newPasswordController.text.length != 6),
                    (_confirmPassController.text !=
                        _newPasswordController.text),
                  );
                  if (Provider.of<UserEditProvider>(context, listen: false)
                      .isValidUpdatePassword()) {
                    _userEditBloc.add(
                      UserEditPasswordEvent(
                        userId: UserInformationHelper.instance.getUserId(),
                        phoneNo: UserInformationHelper.instance
                            .getUserInformation()
                            .phoneNo,
                        oldPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: 500,
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void backToPreviousPage(BuildContext context) {
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).resetPasswordErr();
    Navigator.pop(context);
  }

  void backToHome(BuildContext context) {
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
  }
}
