import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankInformationWidget extends StatelessWidget {
  final double width;
  final double? height;
  final BankAccountDTO bankAccountDTO;

  const BankInformationWidget({
    super.key,
    required this.width,
    required this.bankAccountDTO,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BoxLayout(
      width: width,
      height: height,
      borderRadius: 5,
      enableShadow: true,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              'assets/images/ic-viet-qr-small.png',
              width: 50,
              height: 50,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankAccountDTO.bankName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: DefaultTheme.GREY_TEXT,
                  ),
                ),
                Text(
                  bankAccountDTO.bankAccountName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  bankAccountDTO.bankAccount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: DefaultTheme.GREEN,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              String bankInformationString =
                  '${bankAccountDTO.bankName}\n${bankAccountDTO.bankAccountName.toUpperCase()}\n${bankAccountDTO.bankAccount}';

              await FlutterClipboard.copy(bankInformationString).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255, 0.5)',
                  webPosition: 'center',
                ),
              );
            },
            child: const Icon(
              Icons.copy_outlined,
              color: DefaultTheme.GREY_TOP_TAB_BAR,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
