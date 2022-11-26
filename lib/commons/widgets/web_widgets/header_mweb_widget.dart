import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/web_widgets/pop_up_menu_web_widget.dart';

class HeaderMwebWidget extends StatelessWidget {
  final String title;
  final bool? isSubHeader;
  final VoidCallback? functionBack;
  final VoidCallback? functionHome;

  const HeaderMwebWidget({
    super.key,
    required this.title,
    this.isSubHeader,
    this.functionBack,
    this.functionHome,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: width,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.8),
          ),
          child: Row(
            children: [
              (isSubHeader != null && isSubHeader!)
                  ? InkWell(
                      onTap: (functionBack == null)
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : functionBack,
                      child: Tooltip(
                        message: 'Trở về',
                        child: Container(
                          width: 25,
                          height: 25,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/images/ic-pop.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 25,
                      height: 25,
                    ),
              const Spacer(),
              (isSubHeader != null && isSubHeader!)
                  ? Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Tooltip(
                      message: 'Trang chủ',
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                      ),
                    ),
              const Spacer(),
              InkWell(
                onTap: () {
                  PopupMenuWebWidget.instance
                      .showPopupMMenu(context, isSubHeader, functionHome);
                },
                child: Tooltip(
                  message: 'Menu',
                  child: Container(
                      width: 25,
                      height: 25,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        size: 20,
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
