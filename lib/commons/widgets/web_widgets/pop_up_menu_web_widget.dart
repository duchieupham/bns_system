import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features_mobile/login/views/login.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class PopupMenuWebWidget {
  const PopupMenuWebWidget._privateConsrtructor();

  static const PopupMenuWebWidget _instance =
      PopupMenuWebWidget._privateConsrtructor();
  static PopupMenuWebWidget get instance => _instance;

  Future<void> showPopupMenu(BuildContext context) async {
    final RelativeRect position = _buttonMenuPosition(context);
    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(children: [
            Image.asset(
              'assets/images/ic-avatar.png',
              width: 50,
              height: 50,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            SizedBox(
              width: 190,
              child: Text(
                '${UserInformationHelper.instance.getUserInformation().lastName} ${UserInformationHelper.instance.getUserInformation().middleName} ${UserInformationHelper.instance.getUserInformation().firstName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Thay đổi giao diện'),
        ),
        PopupMenuItem<int>(
          value: 2,
          onTap: () async {
            await UserInformationHelper.instance.initialUserInformationHelper();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
          child: const Text(
            'Đăng xuất',
            style: TextStyle(
              color: DefaultTheme.RED_TEXT,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showPopupMMenu(BuildContext context, bool? isSubHeader) async {
    final RelativeRect position = _buttonMenuPosition(context);
    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(children: [
            Image.asset(
              'assets/images/ic-avatar.png',
              width: 50,
              height: 50,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            SizedBox(
              width: 190,
              child: Text(
                '${UserInformationHelper.instance.getUserInformation().lastName} ${UserInformationHelper.instance.getUserInformation().middleName} ${UserInformationHelper.instance.getUserInformation().firstName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
        if (isSubHeader != null && isSubHeader)
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Trang chủ'),
          ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('Giao dịch'),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Text('Mã QR'),
        ),
        const PopupMenuItem<int>(
          value: 4,
          child: Text('Thay đổi giao diện'),
        ),
        PopupMenuItem<int>(
          value: 5,
          onTap: () async {
            await UserInformationHelper.instance.initialUserInformationHelper();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
          child: const Text(
            'Đăng xuất',
            style: TextStyle(
              color: DefaultTheme.RED_TEXT,
            ),
          ),
        ),
      ],
    );
  }

  RelativeRect _buttonMenuPosition(BuildContext context) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    const Offset offset = Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
      ),
      offset & overlay.size,
    );
    return position;
  }
}