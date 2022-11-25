import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/web_widgets/pop_up_menu_web_widget.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class HeaderWebWidget extends StatelessWidget {
  final String title;
  final bool? isSubHeader;
  final VoidCallback? function;

  const HeaderWebWidget({
    super.key,
    required this.title,
    this.isSubHeader,
    this.function,
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
              SizedBox(
                width: (isSubHeader != null && isSubHeader!) ? 0 : 90,
              ),
              (isSubHeader != null && isSubHeader!)
                  ? InkWell(
                      onTap: (function == null)
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : function,
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
                  : const SizedBox(),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              (isSubHeader != null && isSubHeader!)
                  ? const SizedBox()
                  : Tooltip(
                      message: 'Trang chủ',
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                      ),
                    ),
              const Spacer(),
              (isSubHeader != null && isSubHeader!)
                  ? InkWell(
                      onTap: () {
                        //
                      },
                      child: Tooltip(
                        message: 'Trang chủ',
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.home_rounded,
                            size: 20,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              (isSubHeader != null && isSubHeader!)
                  ? const Padding(padding: EdgeInsets.only(left: 5))
                  : const SizedBox(),
              InkWell(
                onHover: (isHover) async {
                  if (isHover) {
                    PopupMenuWebWidget.instance.showPopupMenu(context);
                  }
                },
                onTap: () {},
                child: Tooltip(
                  message: 'Tài khoản',
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(width),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Image.asset(
                          'assets/images/ic-avatar.png',
                          width: 35,
                          height: 35,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          UserInformationHelper.instance
                              .getUserInformation()
                              .firstName,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
