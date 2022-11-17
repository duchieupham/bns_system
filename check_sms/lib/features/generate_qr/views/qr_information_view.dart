import 'dart:ui';

import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/time_utils.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/dialog_widget.dart';
import 'package:check_sms/commons/widgets/qr_information_widget.dart';
import 'package:check_sms/commons/widgets/qr_statistic_widget.dart';
import 'package:check_sms/features/generate_qr/views/create_qr.dart';
import 'package:check_sms/features/personal/blocs/bank_manage_bloc.dart';
import 'package:check_sms/features/personal/events/bank_manage_event.dart';
import 'package:check_sms/features/personal/states/bank_manage_state.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:check_sms/services/providers/bank_account_provider.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class QRInformationView extends StatelessWidget {
  const QRInformationView({Key? key}) : super(key: key);
  static late BankManageBloc _bankManageBloc;
  static final List<BankAccountDTO> _bankAccounts = [];
  static final PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  static final List<Widget> _cardWidgets = [];

  void initialServices(BuildContext context) {
    _bankManageBloc = BlocProvider.of(context);
    _bankManageBloc.add(BankManageEventGetList(
        userId: UserInformationHelper.instance.getUserId()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-qr.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.only(top: 40)),
            Expanded(
              child: BlocConsumer<BankManageBloc, BankManageState>(
                listener: ((context, state) {
                  if (state is BankManageListSuccessState) {
                    Provider.of<BankAccountProvider>(context, listen: false)
                        .updateIndex(0);
                    if (_pageController.positions.isNotEmpty) {
                      _pageController.jumpToPage(0);
                    }
                    if (_bankAccounts.isEmpty) {
                      _bankAccounts.addAll(state.list);
                      for (BankAccountDTO bankAccountDTO in _bankAccounts) {
                        QRStatisticWidget qrWidget = QRStatisticWidget(
                            key: PageStorageKey(bankAccountDTO.bankCode),
                            bankAccountDTO: bankAccountDTO);
                        _cardWidgets.add(qrWidget);
                      }
                    }
                  }
                }),
                builder: ((context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: (_bankAccounts.isEmpty)
                            ? const SizedBox()
                            : SizedBox(
                                width: width,
                                child: PageView(
                                  key: const PageStorageKey(
                                      'QR_STATIC_PAGE_VIEW'),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _bankAccounts.length,
                                    itemBuilder: ((context, index) => _buildDot(
                                        (index == page.indexSelected))));
                              }),
                            ),
                    ],
                  );
                }),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonWidget(
                width: width,
                text: 'Chia sẻ mã QR của bạn',
                textColor: DefaultTheme.GREEN,
                bgColor: Theme.of(context).cardColor,
                function: () {
                  DialogWidget.instance.openTransactionFormattedDialog(
                    context,
                    'Viettin Bank',
                    'VietinBank:21/01/2022 09:20|TK:115000067275|GD:-1,817,432VND|SDC:160,063,611VND|ND:CT DEN:000522831193 CN CTY TNHH MTV VIEN THONG Q.TE FPT TT HD SO 0000111 ~',
                    TimeUtils.instance.formatTime('15/11/2022 13:58'),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonWidget(
                width: width,
                text: 'Tạo mã QR thanh toán',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateQR(),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 100),
            ),
          ],
        ));
    /*  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*const Text(
            'Mã QR của bạn',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),*/
          const Text(
            'Mã QR này là mã QR tĩnh và không chứa thông tin số tiền thanh toán.',
            style: TextStyle(
                color: DefaultTheme.GREY_TEXT, fontStyle: FontStyle.italic),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Align(
            alignment: Alignment.center,
            child: QRInformationWidget(width: width * 0.9),
          ),
          const Spacer(),
          ButtonWidget(
            width: width,
            text: 'Chia sẻ mã QR của bạn',
            textColor: DefaultTheme.GREEN,
            bgColor: Theme.of(context).buttonColor,
            function: () {
              DialogWidget.instance.openTransactionFormattedDialog(
                context,
                'Viettin Bank',
                'VietinBank:21/01/2022 09:20|TK:115000067275|GD:-1,817,432VND|SDC:160,063,611VND|ND:CT DEN:000522831193 CN CTY TNHH MTV VIEN THONG Q.TE FPT TT HD SO 0000111 ~',
                TimeUtils.instance.formatTime('15/11/2022 13:58'),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ButtonWidget(
            width: width,
            text: 'Tạo mã QR thanh toán',
            textColor: DefaultTheme.WHITE,
            bgColor: DefaultTheme.GREEN,
            function: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateQR(),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  */
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
