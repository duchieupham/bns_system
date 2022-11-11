import 'package:check_sms/features/generate_qr/views/qr_generator.dart';
import 'package:check_sms/features/log_sms/sms_list.dart';
import 'package:check_sms/features/personal/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:check_sms/services/providers/page_select_provider.dart';
import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/time_utils.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //page controller
  static final PageController _pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
  }

  //list page
  static const List<Widget> _homeScreens = [
    QRGeneratorScreen(
      key: PageStorageKey('QR_GENERATOR_PAGE'),
    ),
    SMSList(
      key: PageStorageKey('SMS_LIST_PAGE'),
    ),
    UserSetting(
      key: PageStorageKey('USER_SETTING_PAGE'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // String value = VietQRUtils.instance.generateCRC(
    //     '00020101021138570010A00000072701270006970403011200110123456780208QRIBFTTA53037045802VN6304');
    // print('------value: $value');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: PageView(
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
          ),
          //header
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
                  padding: EdgeInsets.only(left: 10, right: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<PageSelectProvider>(
                          builder: (context, page, child) {
                        return Text(
                          _getTitlePaqe(context, page.indexSelected),
                          style: TextStyle(
                            fontFamily: 'NewYork',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        );
                      }),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              alignment: Alignment.center,
              height: 70,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
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
              width: MediaQuery.of(context).size.width * 0.75,
              child: Stack(
                children: [
                  Consumer<PageSelectProvider>(
                    builder: (context, page, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          color:
              (isSelected) ? Theme.of(context).hoverColor : Colors.transparent,
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
  String _getTitlePaqe(BuildContext context, int indexSelected) {
    String title = '';
    if (indexSelected == 0) {
      title = 'Tạo mã QR';
    }
    if (indexSelected == 1) {
      title =
          '${TimeUtils.instance.getCurrentDateInWeek()}\n${TimeUtils.instance.getCurentDate()}';
    }
    if (indexSelected == 2) {
      title = 'Cá nhân';
    }
    return title;
  }
}
