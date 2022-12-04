import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/setting_bank_sheet.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/frames/bank_manage_frame.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_select_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BankManageView extends StatelessWidget {
  const BankManageView({Key? key}) : super(key: key);

  static late BankManageBloc _bankManageBloc;
  static final List<BankAccountDTO> _bankAccounts = [];
  static final PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  static final List<Widget> _cardWidgets = [];
  static final List<Widget> _cardWebWidgets = [];
  static final TextEditingController _bankAccountController =
      TextEditingController();
  static final TextEditingController _bankAccountNameController =
      TextEditingController();

  void initialServices(BuildContext context) {
    _bankManageBloc = BlocProvider.of(context);
    _bankManageBloc.add(BankManageEventGetList(
        userId: UserInformationHelper.instance.getUserId()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocConsumer<BankManageBloc, BankManageState>(
        listener: ((context, state) {
          if (state is BankManageListSuccessState) {
            Provider.of<BankAccountProvider>(context, listen: false)
                .updateIndex(0);
            _bankAccounts.clear();
            _cardWebWidgets.clear();
            _cardWidgets.clear();
            if (_bankAccounts.isEmpty) {
              _bankAccounts.addAll(state.list);
              for (BankAccountDTO bankAccountDTO in _bankAccounts) {
                BankCardWidget cardWidget = BankCardWidget(
                  key: PageStorageKey(bankAccountDTO.bankCode),
                  width: width,
                  bankAccountDTO: bankAccountDTO,
                  isRemove: true,
                );
                BankCardWidget cardWebWidget = BankCardWidget(
                  key: PageStorageKey(bankAccountDTO.bankCode),
                  width: width,
                  bankAccountDTO: bankAccountDTO,
                  isRemove: true,
                  margin: false,
                );
                _cardWidgets.add(cardWidget);
                _cardWebWidgets.add(cardWebWidget);
              }
            }
          }
          if (state is BankManageLoadingState) {
            DialogWidget.instance.openLoadingDialog(context);
          }
          if (state is BankManageListFailedState) {
            DialogWidget.instance.openMsgDialog(context,
                'Không thể tải danh sách tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
          }
          if (state is BankManageAddFailedState) {
            DialogWidget.instance.openMsgDialog(context,
                'Không thể thêm tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
          }
          if (state is BankManageRemoveFailedState) {
            DialogWidget.instance.openMsgDialog(context,
                'Không thể xoá tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
          }
          if (state is BankManageRemoveSuccessState ||
              state is BankManageAddSuccessState) {
            //close loading dialog
            Navigator.pop(context);
            //
            _bankAccounts.clear();
            _cardWebWidgets.clear();
            _cardWidgets.clear();
            _bankManageBloc.add(BankManageEventGetList(
                userId: UserInformationHelper.instance.getUserId()));
            Navigator.pop(context);
          }
        }),
        builder: ((context, state) {
          return BankManageFrame(
            width: width,
            mobileChilren: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SubHeader(
                    title: 'Tài khoản ngân hàng',
                    function: () {
                      Provider.of<BankAccountProvider>(context, listen: false)
                          .updateIndex(0);
                      Navigator.pop(context);
                    }),
                (_bankAccounts.isEmpty)
                    ? Container(
                        width: width,
                        height: 200,
                        alignment: Alignment.center,
                        child: const Text(
                          'Chưa có tài khoản ngân hàng nào được thêm.',
                          style: TextStyle(color: DefaultTheme.GREY_TEXT),
                        ),
                      )
                    : SizedBox(
                        width: width,
                        height: 200,
                        child: PageView(
                          key: const PageStorageKey('CARD_PAGE_VIEW'),
                          // physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (index) {
                            Provider.of<BankAccountProvider>(context,
                                    listen: false)
                                .updateIndex(index);
                          },
                          children: _cardWidgets,
                        ),
                      ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                (_bankAccounts.isEmpty)
                    ? const SizedBox()
                    : Container(
                        width: width,
                        height: 10,
                        alignment: Alignment.center,
                        child: Consumer<BankAccountProvider>(
                            builder: (context, page, child) {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _bankAccounts.length,
                              itemBuilder: ((context, index) =>
                                  _buildDot((index == page.indexSelected))));
                        }),
                      ),
                const Spacer(),
                ButtonWidget(
                  width: width - 40,
                  text: 'Thêm tài khoản ngân hàng',
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.GREEN,
                  function: () async {
                    List<String> banks =
                        Provider.of<BankSelectProvider>(context, listen: false)
                            .getListAvailableBank();
                    resetAddingBankForm(context);
                    await SettingBankSheet.instance.openAddingFormCard(
                        context,
                        banks,
                        _bankAccountController,
                        _bankAccountNameController);
                  },
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20))
              ],
            ),
            webChildren: GridView.builder(
              itemCount: _bankAccounts.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (ScreenResolutionUtils.instance
                        .checkHomeResize(width, 1050))
                    ? 3
                    : 2,
                childAspectRatio: 1.7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 340,
                  height: 200,
                  child: (index == 0)
                      ? UnconstrainedBox(
                          child: InkWell(
                            onTap: () async {
                              List<String> banks =
                                  Provider.of<BankSelectProvider>(context,
                                          listen: false)
                                      .getListAvailableBank();
                              resetAddingBankForm(context);
                              await openAddBank(
                                context,
                                banks,
                                _bankAccountController,
                                _bankAccountNameController,
                              );
                            },
                            child: Container(
                              width: 340,
                              height: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    DefaultTheme.GREY_BUTTON.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    size: 50,
                                    color:
                                        DefaultTheme.GREY_TEXT.withOpacity(0.6),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  const Text(
                                    'Thêm tài khoản ngân hàng',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: DefaultTheme.GREY_TEXT,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : _cardWebWidgets[index - 1],
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Future<void> openAddBank(
    BuildContext context,
    List<String> banks,
    TextEditingController bankAccountController,
    TextEditingController bankAccountNameController,
  ) {
    final BankManageBloc bankManageBloc = BlocProvider.of(context);
    String bankSelected = banks.first;
    double width = MediaQuery.of(context).size.width;
    return DialogWidget.instance.openContentDialog(
      context,
      null,
      Consumer<BankSelectProvider>(
        builder: ((context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Text(
                'Thêm tài khoản ngân hàng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              BorderLayout(
                width: width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                isError: value.bankSelectErr,
                child: DropdownButton<String>(
                  value: bankSelected,
                  icon: Image.asset(
                    'assets/images/ic-dropdown.png',
                    width: 30,
                    height: 30,
                  ),
                  dropdownColor: Theme.of(context).cardColor,
                  focusColor: Theme.of(context).cardColor,
                  elevation: 0,
                  style: const TextStyle(fontSize: 15),
                  underline: const SizedBox(
                    height: 0,
                  ),
                  isExpanded: true,
                  onChanged: (String? selected) {
                    if (selected == null) {
                      bankSelected = banks.first;
                      //    value.updateBankSelected(banks.first);
                    } else {
                      bankSelected = selected;
                      value.updateBankSelected(selected);
                      value.updateErrs(
                        (value.bankSelected == 'Chọn ngân hàng'),
                        value.bankAccountErr,
                        value.bankAccountNameErr,
                      );
                    }
                  },
                  items: banks.map<DropdownMenuItem<String>>((String value) {
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
                    'Vui lòng chọn Ngân hàng.',
                    style:
                        TextStyle(color: DefaultTheme.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              BorderLayout(
                width: width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                isError: value.bankAccountErr,
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
                    'Số tài khoản không đúng định dạng.',
                    style:
                        TextStyle(color: DefaultTheme.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              BorderLayout(
                width: width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                isError: value.bankAccountNameErr,
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
                    'Tên tài khoản không được để trống.',
                    style:
                        TextStyle(color: DefaultTheme.RED_TEXT, fontSize: 13),
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
                          !StringUtils.instance
                              .isNumeric(bankAccountController.text)),
                      (bankAccountNameController.text.isEmpty));
                  if (!value.bankSelectErr &&
                      !value.bankAccountErr &&
                      !value.bankAccountNameErr) {
                    if (bankSelected != 'Chọn ngân hàng') {
                      BankAccountDTO dto = BankAccountDTO(
                        bankAccount: bankAccountController.text,
                        bankAccountName: bankAccountNameController.text,
                        bankCode: bankSelected.split('-')[0].trim(),
                        bankName: BankInformationUtil.instance
                            .getBankNameFromSelectBox(bankSelected),
                      );
                      bankManageBloc.add(BankManageEventAddDTO(
                          userId: UserInformationHelper.instance.getUserId(),
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
    );
  }

  resetAddingBankForm(BuildContext context) {
    _bankAccountController.clear();
    _bankAccountNameController.clear();
    Provider.of<BankSelectProvider>(context, listen: false)
        .updateErrs(false, false, false);
  }

  Widget _buildDot(bool isSelected) {
    return Container(
      width: (isSelected) ? 20 : 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: (isSelected)
            ? Border.all(color: DefaultTheme.GREY_LIGHT, width: 0.5)
            : null,
        color: (isSelected) ? DefaultTheme.WHITE : DefaultTheme.GREY_LIGHT,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
