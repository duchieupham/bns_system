import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/setting_bank_sheet.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
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
      body: Column(
        children: [
          SubHeader(
              title: 'Tài khoản ngân hàng',
              function: () {
                Provider.of<BankAccountProvider>(context, listen: false)
                    .updateIndex(0);
                Navigator.pop(context);
              }),
          BlocConsumer<BankManageBloc, BankManageState>(
            listener: ((context, state) {
              if (state is BankManageListSuccessState) {
                Provider.of<BankAccountProvider>(context, listen: false)
                    .updateIndex(0);
                if (_bankAccounts.isEmpty) {
                  _bankAccounts.addAll(state.list);
                  for (BankAccountDTO bankAccountDTO in _bankAccounts) {
                    BankCardWidget cardWidget = BankCardWidget(
                      key: PageStorageKey(bankAccountDTO.bankCode),
                      bankAccountDTO: bankAccountDTO,
                      isRemove: true,
                    );
                    _cardWidgets.add(cardWidget);
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
                _cardWidgets.clear();
                _bankManageBloc.add(BankManageEventGetList(
                    userId: UserInformationHelper.instance.getUserId()));
                Navigator.pop(context);
              }
            }),
            builder: ((context, state) {
              return Visibility(
                visible: _bankAccounts.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (_bankAccounts.isEmpty)
                        ? const SizedBox()
                        : Container(
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
                                  itemBuilder: ((context, index) => _buildDot(
                                      (index == page.indexSelected))));
                            }),
                          ),
                  ],
                ),
              );
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
              await SettingBankSheet.instance
                  .openAddingFormCard(context, banks, _bankAccountController,
                      _bankAccountNameController)
                  .then((value) {
                _bankAccountController.clear();
                _bankAccountNameController.clear();
                Provider.of<BankSelectProvider>(context, listen: false)
                    .updateBankSelected(banks.first);
                Provider.of<BankSelectProvider>(context, listen: false)
                    .updateErrs(false, false, false);
              });
            },
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
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
