import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
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
import 'package:vierqr/layouts/box_layout.dart';
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
  static final PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  static final PageController _pageOtherController =
      PageController(initialPage: 0, keepPage: false);
  static final List<BankAccountDTO> _bankAccounts = [];
  static final List<BankAccountDTO> _bankOtherAccounts = [];
  static final List<Widget> _cardWidgets = [];
  static final List<Widget> _cardWebWidgets = [];
  static final List<Widget> _cardOtherWidgets = [];
  static final List<Widget> _cardOtherWebWidgets = [];

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
            _bankOtherAccounts.clear();
            _cardOtherWidgets.clear();
            _cardOtherWebWidgets.clear();
            if (_bankAccounts.isEmpty && state.list.isNotEmpty) {
              _bankAccounts.addAll(state.list);
              for (BankAccountDTO bankAccountDTO in _bankAccounts) {
                BankCardWidget cardWidget = BankCardWidget(
                  key: PageStorageKey(bankAccountDTO.bankCode),
                  width: width,
                  bankAccountDTO: bankAccountDTO,
                  isMenuShow: true,
                  isDelete: true,
                  roleInsert: Stringify.ROLE_CARD_MEMBER_ADMIN,
                );
                BankCardWidget cardWebWidget = BankCardWidget(
                  key: PageStorageKey(bankAccountDTO.bankCode),
                  width: width,
                  bankAccountDTO: bankAccountDTO,
                  isMenuShow: true,
                  isDelete: true,
                  margin: false,
                  roleInsert: Stringify.ROLE_CARD_MEMBER_ADMIN,
                );
                _cardWidgets.add(cardWidget);
                _cardWebWidgets.add(cardWebWidget);
              }
            }
            if (_bankOtherAccounts.isEmpty && state.listOther.isNotEmpty) {
              _bankOtherAccounts.addAll(state.listOther);
              for (BankAccountDTO bankAccountDTO in _bankOtherAccounts) {
                BankCardWidget cardWidget = BankCardWidget(
                  key: PageStorageKey(bankAccountDTO.bankCode),
                  width: width,
                  bankAccountDTO: bankAccountDTO,
                  isMenuShow: true,
                  isDelete: false,
                  roleInsert: Stringify.ROLE_CARD_MEMBER_MANAGER,
                );
                BankCardWidget cardWebWidget = BankCardWidget(
                  key: PageStorageKey(bankAccountDTO.bankCode),
                  width: width,
                  bankAccountDTO: bankAccountDTO,
                  isMenuShow: true,
                  isDelete: false,
                  margin: false,
                  roleInsert: Stringify.ROLE_CARD_MEMBER_MANAGER,
                );
                _cardOtherWidgets.add(cardWidget);
                _cardOtherWebWidgets.add(cardWebWidget);
              }
            }
          }
          if (state is BankManageLoadingState) {
            DialogWidget.instance.openLoadingDialog(context);
          }
          if (state is BankManageListFailedState) {
            DialogWidget.instance.openMsgDialog(
                context: context,
                title: 'Không thể tải danh sách',
                msg:
                    'Không thể tải danh sách tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
          }
          if (state is BankManageAddFailedState) {
            DialogWidget.instance.openMsgDialog(
                context: context,
                title: 'Không thể tải danh sách',
                msg:
                    'Không thể thêm tài khoản ngân hàng. Vui lòng kiểm tra lại kết nối mạng');
          }
          if (state is BankManageRemoveFailedState) {
            DialogWidget.instance.openMsgDialog(
                context: context,
                title: 'Không thể tải danh sách',
                msg:
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
            _bankOtherAccounts.clear();
            _cardOtherWidgets.clear();
            _cardOtherWebWidgets.clear();
            _bankManageBloc.add(BankManageEventGetList(
                userId: UserInformationHelper.instance.getUserId()));
            Navigator.pop(context);
          }
        }),
        builder: ((context, state) {
          if (state is BankManageListSuccessState) {
            if (state.list.isEmpty) {
              _bankAccounts.clear();
              _cardWebWidgets.clear();
              _cardWidgets.clear();
            }
            if (state.listOther.isEmpty) {
              _bankOtherAccounts.clear();
              _cardOtherWidgets.clear();
              _cardOtherWebWidgets.clear();
            }
          }
          return BankManageFrame(
            width: width,
            mobileChilren: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SubHeader(
                    title: 'Tài khoản ngân hàng',
                    function: () {
                      Provider.of<BankAccountProvider>(context, listen: false)
                          .reset();
                      Navigator.pop(context);
                    }),
                Consumer<BankAccountProvider>(
                    builder: (context, provider, child) {
                  return BoxLayout(
                    width: width * 0.7 + 10,
                    height: 35,
                    borderRadius: 5,
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabButton(
                          context: context,
                          isSelected: (provider.indexMenu == 0),
                          width: width * 0.35,
                          text: 'Của bạn',
                          function: () {
                            provider.updateIndexMenu(0);
                            provider.updateIndex(0);
                            provider.updateOtherIndex(0);
                          },
                        ),
                        _buildTabButton(
                          context: context,
                          isSelected: (provider.indexMenu == 1),
                          width: width * 0.35,
                          text: 'Khác',
                          function: () {
                            provider.updateIndexMenu(1);
                            provider.updateIndex(0);
                            provider.updateOtherIndex(0);
                          },
                        ),
                      ],
                    ),
                  );
                }),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Consumer<BankAccountProvider>(
                    builder: (context, provider, child) {
                  return (provider.indexMenu == 0)
                      ? Column(
                          children: [
                            (_bankAccounts.isEmpty)
                                ? const SizedBox()
                                : SizedBox(
                                    width: width,
                                    height: 200,
                                    child: PageView(
                                      key: const PageStorageKey(
                                          'CARD_PAGE_VIEW'),
                                      // physics: const NeverScrollableScrollPhysics(),
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        Provider.of<BankAccountProvider>(
                                                context,
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
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _bankAccounts.length,
                                      itemBuilder: ((context, index) =>
                                          _buildDot(
                                            (index == provider.indexSelected),
                                          )),
                                    ),
                                  ),
                          ],
                        )
                      : Column(
                          children: [
                            (_bankOtherAccounts.isEmpty)
                                ? const SizedBox()
                                : SizedBox(
                                    width: width,
                                    height: 200,
                                    child: PageView(
                                      key: const PageStorageKey(
                                          'CARD_PAGE_VIEW_OTHER'),
                                      // physics: const NeverScrollableScrollPhysics(),
                                      controller: _pageOtherController,
                                      onPageChanged: (index) {
                                        Provider.of<BankAccountProvider>(
                                                context,
                                                listen: false)
                                            .updateOtherIndex(index);
                                      },
                                      children: _cardOtherWidgets,
                                    ),
                                  ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            (_bankOtherAccounts.isEmpty)
                                ? const SizedBox()
                                : Container(
                                    width: width,
                                    height: 10,
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _bankOtherAccounts.length,
                                      itemBuilder: ((context, index) =>
                                          _buildDot(
                                            (index ==
                                                provider.indexOtherSelected),
                                          )),
                                    ),
                                  ),
                          ],
                        );
                }),
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
            menu: Consumer<BankAccountProvider>(
                builder: (context, provider, child) {
              return Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 50)),
                  _buildButtonMenu(
                      context: context,
                      isSelected: provider.indexMenu == 0,
                      text: 'Tài khoản của bạn',
                      function: () {
                        provider.updateIndexMenu(0);
                      }),
                  _buildButtonMenu(
                      context: context,
                      isSelected: provider.indexMenu == 1,
                      text: 'Tài khoản khác',
                      function: () {
                        provider.updateIndexMenu(1);
                      }),
                ],
              );
            }),
            webChildren: Consumer<BankAccountProvider>(
                builder: (context, provider, child) {
              return (provider.indexMenu == 0)
                  ? GridView.builder(
                      key: const Key('LIST_BANK'),
                      itemCount: _bankAccounts.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (PlatformUtils.instance.resizeWhen(width, 1250))
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
                                          Provider.of<BankSelectProvider>(
                                                  context,
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
                                        color: DefaultTheme.GREY_BUTTON
                                            .withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_rounded,
                                            size: 50,
                                            color: DefaultTheme.GREY_TEXT
                                                .withOpacity(0.6),
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
                    )
                  : SizedBox(
                      child: (_bankOtherAccounts.isNotEmpty)
                          ? GridView.builder(
                              key: const Key('LIST_BANK_OTHER'),
                              itemCount: _bankOtherAccounts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: (PlatformUtils.instance
                                        .resizeWhen(width, 1250))
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
                                  child: _cardOtherWebWidgets[index],
                                );
                              },
                            )
                          : const SizedBox(),
                    );
            }),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      const Uuid uuid = Uuid();
                      BankAccountDTO dto = BankAccountDTO(
                        id: uuid.v1(),
                        bankAccount: bankAccountController.text,
                        bankAccountName: bankAccountNameController.text,
                        bankCode: bankSelected.split('-')[0].trim(),
                        bankName: BankInformationUtil.instance
                            .getBankNameFromSelectBox(bankSelected),
                      );
                      bankManageBloc.add(BankManageEventAddDTO(
                        userId: UserInformationHelper.instance.getUserId(),
                        dto: dto,
                        phoneNo: UserInformationHelper.instance
                            .getUserInformation()
                            .phoneNo,
                      ));
                    }
                  } else {
                    DialogWidget.instance.openMsgDialog(
                        context: context,
                        title: 'Không thể thêm tài khoản',
                        msg:
                            'Không thể thêm tài khoản ngân hàng. Vui lòng nhập đầy đủ và chính xác thông tin tài khoản ngân hàng.');
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

  Widget _buildTabButton({
    required BuildContext context,
    required bool isSelected,
    required String text,
    required VoidCallback function,
    required double width,
  }) {
    return ButtonWidget(
      width: width,
      height: 30,
      text: text,
      borderRadius: 5,
      textColor: Theme.of(context).hintColor,
      bgColor: (isSelected)
          ? Theme.of(context).canvasColor
          : DefaultTheme.TRANSPARENT,
      function: function,
    );
  }

  Widget _buildButtonMenu({
    required BuildContext context,
    required bool isSelected,
    required String text,
    required VoidCallback function,
  }) {
    return ButtonWidget(
      width: 180,
      height: 30,
      text: text,
      borderRadius: 5,
      textColor: DefaultTheme.GREEN,
      // bgColor: (isSelected)
      //     ? DefaultTheme.GREEN.withOpacity(0.3)
      //     : DefaultTheme.TRANSPARENT,
      bgColor: (isSelected)
          ? Theme.of(context).canvasColor
          : DefaultTheme.TRANSPARENT,
      function: function,
    );
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
