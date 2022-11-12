import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/sub_header.widget.dart';
import 'package:check_sms/features/generate_qr/widgets/input_content_widget.dart';
import 'package:check_sms/features/generate_qr/widgets/input_ta_widget.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateQR extends StatefulWidget {
  const CreateQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateQR();
}

class _CreateQR extends State<CreateQR> {
  static final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  static const List<Widget> _pages = [
    InputTAWidget(
      key: PageStorageKey('INPUT_TA_PAGE'),
    ),
    InputContentWidget(
      key: PageStorageKey('INPUT_CONTENT_PAGE'),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          const SubHeader(title: 'Tạo mã QR'),
          Expanded(
            child: PageView(
              key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<CreateQRPageSelectProvider>(context, listen: false)
                    .updateIndex(index);
              },
              children: _pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Consumer<CreateQRPageSelectProvider>(
              builder: (context, page, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(0, page.indexSelected),
                    const Padding(
                        padding: EdgeInsets.only(
                      left: 5,
                    )),
                    _buildDot(1, page.indexSelected),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<CreateQRPageSelectProvider>(
                builder: (context, page, child) {
              return (page.indexSelected == 0)
                  ? ButtonWidget(
                      width: width,
                      text: 'Tiếp theo',
                      textColor: DefaultTheme.GREEN,
                      bgColor: Theme.of(context).buttonColor,
                      function: () {
                        _animatedToPage(1);
                      },
                    )
                  : ButtonWidget(
                      width: width,
                      text: 'Tạo mã QR',
                      textColor: DefaultTheme.WHITE,
                      bgColor: DefaultTheme.GREEN,
                      function: () {
                        _animatedToPage(1);
                      },
                    );
            }),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20))
        ],
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

  Widget _buildDot(int index, int indexSelected) {
    return Container(
      width: 25,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (index == indexSelected)
            ? DefaultTheme.WHITE
            : DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.6),
      ),
    );
  }
}
