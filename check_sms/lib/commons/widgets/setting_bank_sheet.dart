import 'dart:ui';

import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/string_utils.dart';
import 'package:check_sms/commons/utils/time_utils.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/dialog_widget.dart';
import 'package:check_sms/commons/widgets/textfield_widget.dart';
import 'package:check_sms/features/personal/blocs/bank_manage_bloc.dart';
import 'package:check_sms/features/personal/events/bank_manage_event.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:check_sms/services/providers/bank_select_provider.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingBankSheet {
  const SettingBankSheet._privateConsrtructor();

  static const SettingBankSheet _instance =
      SettingBankSheet._privateConsrtructor();
  static SettingBankSheet get instance => _instance;

  Future openAddingFormCard(
      BuildContext context,
      List<String> banks,
      TextEditingController bankAccountController,
      TextEditingController bankAccountNameController) {
    final double width = MediaQuery.of(context).size.width;
    final BankManageBloc bankManageBloc = BlocProvider.of(context);
    String bankSelected = banks.first;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Consumer<BankSelectProvider>(
                    builder: ((context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          const Text(
                            'Thêm tài khoản ngân hàng',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: (value.bankSelectErr)
                                  ? DefaultTheme.RED_TEXT.withOpacity(0.2)
                                  : Theme.of(context).buttonColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              value: bankSelected,
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
                                  bankSelected = banks.first;
                                  //    value.updateBankSelected(banks.first);
                                } else {
                                  bankSelected = selected;
                                  value.updateBankSelected(selected);
                                }
                              },
                              items: banks.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: SizedBox(
                                    width: width - 120,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Visibility(
                            visible: value.bankSelectErr,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                'Vui lòng chọn Ngân hàng để thêm tài khoản.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: (value.bankAccountErr)
                                  ? DefaultTheme.RED_TEXT.withOpacity(0.2)
                                  : Theme.of(context).buttonColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFieldWidget(
                                width: width,
                                hintText: 'Số tài khoản',
                                controller: bankAccountController,
                                keyboardAction: TextInputAction.next,
                                onChange: (value) {},
                                inputType: TextInputType.number,
                                isObscureText: false),
                          ),
                          Visibility(
                            visible: value.bankAccountErr,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                'Số tài khoản cần đúng định dạng và không được để trống.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: (value.bankAccountNameErr)
                                  ? DefaultTheme.RED_TEXT.withOpacity(0.2)
                                  : Theme.of(context).buttonColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFieldWidget(
                                width: width,
                                hintText: 'Tên tài khoản',
                                controller: bankAccountNameController,
                                keyboardAction: TextInputAction.done,
                                onChange: (value) {},
                                inputType: TextInputType.text,
                                isObscureText: false),
                          ),
                          Visibility(
                            visible: value.bankAccountNameErr,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                'Vui lòng nhập tên tài khoản.',
                                style: TextStyle(
                                    color: DefaultTheme.RED_TEXT, fontSize: 13),
                              ),
                            ),
                          ),
                          const Spacer(),
                          ButtonWidget(
                            width: width - 40,
                            text: 'Thêm tài khoản ngân hàng',
                            textColor: DefaultTheme.WHITE,
                            bgColor: DefaultTheme.GREEN,
                            function: () {
                              value.updateErrs(
                                  (value.bankSelected == 'Chọn ngân hàng'),
                                  (bankAccountController.text.isEmpty ||
                                      !StringUtils.instance.isNumeric(
                                          bankAccountController.text)),
                                  (bankAccountNameController.text.isEmpty));
                              if (!value.bankSelectErr &&
                                  !value.bankAccountErr &&
                                  !value.bankAccountNameErr) {
                                if (bankSelected != 'Chọn ngân hàng') {
                                  List<String> bankNameChars =
                                      bankSelected.split('-');
                                  String bankName = '';
                                  for (int i = 0;
                                      i < bankNameChars.length;
                                      i++) {
                                    if (i != 0) {
                                      bankName += bankNameChars[i];
                                    }
                                  }
                                  bankName.trim();
                                  BankAccountDTO dto = BankAccountDTO(
                                    bankAccount: bankAccountController.text,
                                    bankAccountName:
                                        bankAccountNameController.text,
                                    bankCode: bankSelected.split('-')[0].trim(),
                                    bankName: bankName,
                                  );
                                  bankManageBloc.add(BankManageEventAddDTO(
                                      userId: UserInformationHelper.instance
                                          .getUserId(),
                                      dto: dto));
                                }
                              } else {
                                DialogWidget.instance.openMsgDialog(context,
                                    'Không thể thêm tài khoản. Vui lòng nhập đầy đủ và chính xác thông tin tài khoản ngân hàng.');
                              }
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future openSettingCard(
      BuildContext context, String userId, String bankAccount) {
    final double width = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              width: 200,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: width,
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: Text(
                            'Bạn có muốn xoá tài khoản $bankAccount ra khỏi danh sách không?',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(
                          color: DefaultTheme.GREY_LIGHT,
                          height: 0.5,
                        ),
                        ButtonWidget(
                          width: width,
                          text: 'Xoá',
                          textColor: DefaultTheme.RED_TEXT,
                          bgColor: DefaultTheme.TRANSPARENT,
                          function: () {
                            final BankManageBloc bankManageBloc =
                                BlocProvider.of(context);
                            bankManageBloc.add(BankManageEventRemoveDTO(
                                userId: userId, bankCode: bankAccount));
                          },
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ButtonWidget(
                    width: width,
                    text: 'Huỷ',
                    textColor: DefaultTheme.BLUE_TEXT,
                    bgColor: Theme.of(context).cardColor.withOpacity(0.8),
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          );
        });
  }
}
