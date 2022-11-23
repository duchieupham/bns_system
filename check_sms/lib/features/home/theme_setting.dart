import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/widgets/checkbox_widget.dart';
import 'package:check_sms/commons/widgets/sub_header_widget.dart';
import 'package:check_sms/services/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingView extends StatelessWidget {
  const ThemeSettingView();

  //theme UI controller
  static late PageController _themeUIController;
  static late ThemeProvider _themeProvider;
  //asset UI list
  static final List<String> _assetList = [
    'assets/images/ic-light-theme.png',
    'assets/images/ic-dark-theme.png',
    'assets/images/ic-system-theme.png',
  ];

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _themeUIController = PageController(
      initialPage: _themeProvider.getThemeIndex(),
      viewportFraction: 0.65,
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubHeader(title: 'Giao diện'),
          Expanded(
            child: ListView(
              children: [
                //UI view
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 60),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: PageView.builder(
                    controller: _themeUIController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _assetList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _assetList[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                //
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: DefaultTheme.cardDecoration(context),
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _assetList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _themeProvider.updateThemeByIndex(index);
                          _themeUIController.animateToPage(
                              _themeProvider.getThemeIndex(),
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeInToLinear);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(getTitleTheme(index)),
                              Spacer(),
                              //check box
                              CheckBoxWidget(
                                check: (Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .getThemeIndex() ==
                                    index),
                                size: 25,
                                function: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: DefaultTheme.GREY_TEXT,
                        height: 0.5,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTitleTheme(int index) {
    String title = '';
    if (index == 0) {
      title = 'Sáng';
    } else if (index == 1) {
      title = 'Tối';
    } else {
      title = 'Hệ thống';
    }
    return title;
  }
}
