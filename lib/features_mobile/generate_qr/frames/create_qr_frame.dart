import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_mweb_widget.dart';
import 'package:vierqr/commons/widgets/web_widgets/header_web_widget.dart';
import 'package:vierqr/features_mobile/home/home.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';

class CreateQRFrame extends StatelessWidget {
  final double width;
  final double height;
  final List<Widget> mobileChildren;
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;

  const CreateQRFrame({
    super.key,
    required this.width,
    required this.height,
    required this.mobileChildren,
    required this.widget1,
    required this.widget2,
    required this.widget3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: (ScreenResolutionUtils.instance.isWeb())
          ? Stack(
              children: [
                ListView(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 100)),
                    UnconstrainedBox(
                      child: Container(
                        width: ScreenResolutionUtils.instance.getDynamicWidth(
                          screenWidth: width,
                          defaultWidth: 800,
                          minWidth: width * 0.8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor,
                        ),
                        child: (ScreenResolutionUtils.instance
                                .checkHomeResize(width, 800))
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 399,
                                    height: 610,
                                    child: widget1,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 610,
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  ),
                                  SizedBox(
                                    width: 400,
                                    height: 610,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 400,
                                          height: 200,
                                          child: widget2,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 20)),
                                        Expanded(
                                          child: widget3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    width: 400,
                                    height: 200,
                                    child: widget2,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  SizedBox(
                                    width: 400,
                                    child: widget1,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  SizedBox(
                                    width: 400,
                                    height: 390,
                                    child: widget3,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 100)),
                  ],
                ),
                (ScreenResolutionUtils.instance.checkHomeResize(width, 800))
                    ? HeaderWebWidget(
                        title: 'Tạo mã VietQR',
                        isSubHeader: true,
                        functionBack: () {
                          Provider.of<CreateQRProvider>(context, listen: false)
                              .reset();
                          Navigator.pop(context);
                        },
                        functionHome: () {
                          Provider.of<CreateQRProvider>(context, listen: false)
                              .reset();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      )
                    : HeaderMwebWidget(
                        title: 'Tạo mã VietQR',
                        isSubHeader: true,
                        functionBack: () {
                          Provider.of<CreateQRProvider>(context, listen: false)
                              .reset();
                          Navigator.pop(context);
                        },
                        functionHome: () {
                          Provider.of<CreateQRProvider>(context, listen: false)
                              .reset();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      ),
              ],
            )
          : Column(
              children: mobileChildren,
            ),
    );
  }
}
