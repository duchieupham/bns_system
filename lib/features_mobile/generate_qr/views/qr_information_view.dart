import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/qr_statistic_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/features_mobile/generate_qr/views/create_qr.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
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
  static final List<GlobalKey> _keys = [];

  void initialServices(BuildContext context) {
    _cardWidgets.clear();
    _bankAccounts.clear();
    _bankManageBloc = BlocProvider.of(context);
    _bankManageBloc.add(BankManageEventGetList(
        userId: UserInformationHelper.instance.getUserId()));
  }

  @override
  Widget build(BuildContext context) {
    print('build qr information widget');
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
                      GlobalKey key = GlobalKey();
                      _keys.add(key);
                      QRStatisticWidget qrWidget = QRStatisticWidget(
                        bankAccountDTO: bankAccountDTO,
                      );
                      RepaintBoundaryWidget repaintBoundaryWidget =
                          RepaintBoundaryWidget(
                              globalKey: key,
                              builder: (key) {
                                return SizedBox(
                                  width: 350,
                                  height: 300,
                                  child: qrWidget,
                                );
                              });
                      _cardWidgets.add(repaintBoundaryWidget);
                    }
                  }
                  Provider.of<CreateQRPageSelectProvider>(context,
                          listen: false)
                      .updateBankAccountDTO(_bankAccounts[0]);
                }
                if (state is BankManageRemoveSuccessState ||
                    state is BankManageAddSuccessState) {
                  _bankAccounts.clear();
                  _cardWidgets.clear();
                  _bankManageBloc.add(BankManageEventGetList(
                      userId: UserInformationHelper.instance.getUserId()));
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
                                key:
                                    const PageStorageKey('QR_STATIC_PAGE_VIEW'),
                                // physics: const NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (index) {
                                  Provider.of<BankAccountProvider>(context,
                                          listen: false)
                                      .updateIndex(index);
                                  Provider.of<CreateQRPageSelectProvider>(
                                          context,
                                          listen: false)
                                      .updateBankAccountDTO(
                                          _bankAccounts[index]);
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
                                  physics: const NeverScrollableScrollPhysics(),
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
              function: () async {
                await ShareUtils.instance.shareImage(_keys[
                    Provider.of<BankAccountProvider>(context, listen: false)
                        .indexSelected]);
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
                    builder: (context) => CreateQR(
                      bankAccountDTO: Provider.of<CreateQRPageSelectProvider>(
                              context,
                              listen: false)
                          .bankAccountDTO,
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 100),
          ),
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