import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/checkbox_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/features_mobile/personal/blocs/user_edit_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/user_edit_event.dart';
import 'package:vierqr/features_mobile/personal/states/user_edit_state.dart';
import 'package:vierqr/features_mobile/personal/views/user_update_password_view.dart';
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
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(
              title: 'Thông tin cá nhân',
              function: () {
                Provider.of<UserEditProvider>(context, listen: false).reset();
                Navigator.pop(context);
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
              }),
              child: Consumer<UserEditProvider>(
                builder: (context, provider, child) {
                  return ListView(
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
                              child: Image.asset('assets/images/ic-avatar.png'),
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
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      ButtonWidget(
                        width: width - 40,
                        text: 'Cập nhật ảnh đại diện',
                        textColor: DefaultTheme.GREEN,
                        bgColor: Theme.of(context).cardColor,
                        function: () {},
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      ButtonWidget(
                        width: width - 40,
                        text: 'Đổi mã PIN',
                        textColor: DefaultTheme.GREEN,
                        bgColor: Theme.of(context).cardColor,
                        function: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const UserUpdatePassword(),
                            ),
                          );
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
                  );
                },
              ),
            ),
          ),
          Padding(
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
                      provider.updateErrors(_firstNameController.text.isEmpty);
                      if (provider.isValidUpdate()) {
                        UserInformationDTO userInformationDTO =
                            UserInformationDTO(
                          userId: UserInformationHelper.instance.getUserId(),
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
}
