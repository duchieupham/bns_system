import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/qr_statistic_widget.dart';
import 'package:vierqr/features_mobile/generate_qr/views/create_qr.dart';
import 'package:vierqr/features_mobile/generate_qr/views/qr_information_view.dart';
import 'package:vierqr/features_mobile/home/frames/home_frame.dart';
import 'package:vierqr/features_mobile/home/widgets/button_navigate_page_widget.dart';
import 'package:vierqr/features_mobile/home/widgets/title_home_web_widget.dart';
import 'package:vierqr/features_mobile/log_sms/sms_list.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
import 'package:vierqr/features_mobile/personal/views/bank_manage.dart';
import 'package:vierqr/features_mobile/personal/views/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'dart:ui';

import 'package:vierqr/services/shared_references/user_information_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //page controller
  static late PageController _pageController;

  //list page
  final List<Widget> _homeScreens = [];
  final CarouselController _carouselController = CarouselController();
  static final List<Widget> _cardWidgets = [];
  static final List<BankAccountDTO> _bankAccounts = [];
  static late BankManageBloc _bankManageBloc;

  //for web

  @override
  void initState() {
    super.initState();
    if (ScreenResolutionUtils.instance.isWeb()) {
      _cardWidgets.clear();
      _bankAccounts.clear();
      _bankManageBloc = BlocProvider.of(context);
      _bankManageBloc.add(BankManageEventGetList(
          userId: UserInformationHelper.instance.getUserId()));
    }
    _pageController = PageController(
      initialPage:
          Provider.of<PageSelectProvider>(context, listen: false).indexSelected,
      keepPage: true,
    );
    _homeScreens.addAll([
      const QRInformationView(
        key: PageStorageKey('QR_GENERATOR_PAGE'),
      ),
      if (!ScreenResolutionUtils.instance.isWeb())
        const SMSList(
          key: PageStorageKey('SMS_LIST_PAGE'),
        ),
      const UserSetting(
        key: PageStorageKey('USER_SETTING_PAGE'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: HomeFrame(
        width: width,
        height: height,
        mobileChildren: [
          PageView(
            key: const PageStorageKey('PAGE_VIEW'),
            allowImplicitScrolling: true,
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              Provider.of<PageSelectProvider>(context, listen: false)
                  .updateIndex(index);
            },
            children: _homeScreens,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<PageSelectProvider>(
                          builder: (context, page, child) {
                        return _getTitlePaqe(context, page.indexSelected);
                      }),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        widget1: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 65,
                height: 65,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(65),
                ),
                child: Image.asset(
                  'assets/images/ic-avatar.png',
                  width: 65,
                  height: 65,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                'Xin chào, ${UserInformationHelper.instance.getUserInformation().firstName}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                '${TimeUtils.instance.getCurrentDateInWeek()}, ${TimeUtils.instance.getCurentDate()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        widget2: Container(
          width: width,
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              TitleHomeWebWidget(
                width: width,
                iconAsset: 'assets/images/ic-qr.png',
                title: 'Mã QR tĩnh',
                description: 'Mã QR không chứa thông tin thanh toán',
              ),
              Expanded(
                child: Container(
                  width: width,
                  color: Theme.of(context).cardColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: width,
                          child: BlocConsumer<BankManageBloc, BankManageState>(
                            listener: ((context, state) {
                              if (state is BankManageListSuccessState) {
                                Provider.of<BankAccountProvider>(context,
                                        listen: false)
                                    .updateIndex(0);
                                if (_bankAccounts.isEmpty) {
                                  _bankAccounts.addAll(state.list);
                                  for (BankAccountDTO bankAccountDTO
                                      in _bankAccounts) {
                                    QRStatisticWidget qrWidget =
                                        QRStatisticWidget(
                                      bankAccountDTO: bankAccountDTO,
                                      isWeb: true,
                                    );
                                    _cardWidgets.add(qrWidget);
                                  }
                                }
                              }
                              if (state is BankManageRemoveSuccessState ||
                                  state is BankManageAddSuccessState) {
                                _bankAccounts.clear();
                                _cardWidgets.clear();
                                _bankManageBloc.add(BankManageEventGetList(
                                    userId: UserInformationHelper.instance
                                        .getUserId()));
                              }
                            }),
                            builder: ((context, state) {
                              return (_bankAccounts.isEmpty)
                                  ? Container(
                                      width: width - 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Mã QR thanh toán chưa được tạo.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: DefaultTheme.GREY_TEXT,
                                            ),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          ButtonIconWidget(
                                            width: 220,
                                            icon: Icons.add_rounded,
                                            title: 'Thêm tài khoản ngân hàng',
                                            bgColor: DefaultTheme.GREEN,
                                            textColor:
                                                Theme.of(context).primaryColor,
                                            function: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BankManageView(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CarouselSlider(
                                          carouselController:
                                              _carouselController,
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            onPageChanged: ((index, reason) {
                                              Provider.of<BankAccountProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateIndex(index);
                                            }),
                                          ),
                                          items: _cardWidgets.map((i) {
                                            return i;
                                          }).toList(),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Tooltip(
                                            message: 'Phóng to mã QR',
                                            child: InkWell(
                                              onTap: () {
                                                QRStatisticWidget qrWidget =
                                                    QRStatisticWidget(
                                                  isWeb: true,
                                                  isExpanded: true,
                                                  bankAccountDTO: _bankAccounts[
                                                      Provider.of<BankAccountProvider>(
                                                              context,
                                                              listen: false)
                                                          .indexSelected],
                                                );
                                                DialogWidget.instance
                                                    .openContentDialog(
                                                  context,
                                                  null,
                                                  qrWidget,
                                                );
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: const Icon(
                                                  Icons.zoom_out_map_rounded,
                                                  color: DefaultTheme.GREY_TEXT,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 130,
                                          left: 0,
                                          child: ButtonNavigatePageWidget(
                                              width: 20,
                                              height: 50,
                                              function: () {
                                                _carouselController.animateToPage(
                                                    Provider.of<BankAccountProvider>(
                                                                context,
                                                                listen: false)
                                                            .indexSelected -
                                                        1);
                                              },
                                              isPrevious: true),
                                        ),
                                        Positioned(
                                          top: 130,
                                          right: 0,
                                          child: ButtonNavigatePageWidget(
                                              width: 20,
                                              height: 50,
                                              function: () {
                                                _carouselController.animateToPage(
                                                    Provider.of<BankAccountProvider>(
                                                                context,
                                                                listen: false)
                                                            .indexSelected +
                                                        1);
                                              },
                                              isPrevious: false),
                                        ),
                                      ],
                                    );
                            }),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      ButtonIconWidget(
                        width: 185,
                        icon: Icons.add_rounded,
                        title: 'Tạo mã QR thanh toán',
                        function: () {
                          if (_bankAccounts.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateQR(
                                  bankAccountDTO: _bankAccounts[
                                      Provider.of<BankAccountProvider>(context,
                                              listen: false)
                                          .indexSelected],
                                ),
                              ),
                            );
                          } else {
                            DialogWidget.instance.openMsgDialog(
                                context: context,
                                title: 'Không thể tạo mã QR thanh toán',
                                msg:
                                    'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
                          }
                        },
                        bgColor: DefaultTheme.GREEN,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        widget3: Container(
          width: width,
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              TitleHomeWebWidget(
                width: width,
                iconAsset: 'assets/images/ic-dashboard.png',
                title: 'Giao dịch',
                description: 'Danh sách các giao dịch gần đây',
              ),
              Expanded(
                child: Container(
                  width: width,
                  alignment: Alignment.center,
                  color: Theme.of(context).cardColor,
                  child: const Text(
                    'Tính năng hiện đang trong giai đoạn phát triển.',
                    style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundAsset: 'assets/images/bg-qr.png',
      ),
      floatingActionButtonLocation: (ScreenResolutionUtils.instance.isWeb())
          ? null
          : FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (ScreenResolutionUtils.instance.isWeb())
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.6),
                      boxShadow: [
                        BoxShadow(
                          color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Stack(
                      children: [
                        Consumer<PageSelectProvider>(
                          builder: (context, page, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _buildShortcut(
                                  0,
                                  page.indexSelected,
                                  context,
                                ),
                                _buildShortcut(
                                  1,
                                  page.indexSelected,
                                  context,
                                ),
                                _buildShortcut(
                                  2,
                                  page.indexSelected,
                                  context,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  //build shorcuts in bottom bar
  _buildShortcut(int index, int indexSelected, BuildContext context) {
    bool isSelected = (index == indexSelected);
    return InkWell(
      onTap: () {
        _animatedToPage(index);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: (isSelected)
              ? Theme.of(context).toggleableActiveColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(
          _getAssetIcon(index, isSelected),
          width: 35,
          height: 35,
        ),
      ),
    );
  }

  //navigate to page
  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  //get image assets
  String _getAssetIcon(int index, bool isSelected) {
    const String prefix = 'assets/images/';
    String assetImage = (index == 0 && isSelected)
        ? 'ic-qr.png'
        : (index == 0 && !isSelected)
            ? 'ic-qr-unselect.png'
            : (index == 1 && isSelected)
                ? 'ic-dashboard.png'
                : (index == 1 && !isSelected)
                    ? 'ic-dashboard-unselect.png'
                    : (index == 2 && isSelected)
                        ? 'ic-user.png'
                        : 'ic-user-unselect.png';
    return '$prefix$assetImage';
  }

  //get title page
  Widget _getTitlePaqe(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected == 0) {
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: const [
            TextSpan(
              text: 'Mã QR tĩnh\n',
            ),
            TextSpan(
              text: 'Đây là mã QR không chứa thông tin thanh toán.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
    if (indexSelected == 1) {
      /* title =
          '${TimeUtils.instance.getCurrentDateInWeek()}\n${TimeUtils.instance.getCurentDate()}';*/
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: [
            const TextSpan(
              text: 'Trang chủ\n',
            ),
            TextSpan(
              text:
                  '${TimeUtils.instance.getCurrentDateInWeek()}, ${TimeUtils.instance.getCurentDate()}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: DefaultTheme.GREY_TEXT,
              ),
            ),
          ],
        ),
      );
    }
    if (indexSelected == 2) {
      titleWidget = const Text(
        'Cá nhân',
        style: TextStyle(
          fontFamily: 'NewYork',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }
    return titleWidget;
  }
}
