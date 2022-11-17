import 'dart:ui';

import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRStatisticWidget extends StatelessWidget {
  final BankAccountDTO bankAccountDTO;

  const QRStatisticWidget({
    Key? key,
    required this.bankAccountDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return UnconstrainedBox(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            alignment: Alignment.center,
            width: width - 60,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: DefaultTheme.WHITE.withOpacity(0.8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.4,
                  child: Image.asset('assets/images/ic-viet-qr.png'),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DefaultTheme.WHITE,
                    border: Border.all(
                      color: DefaultTheme.GREY_TEXT,
                      width: 0.5,
                    ),
                  ),
                  child: QrImage(
                    data: 1.toString(),
                    version: QrVersions.auto,
                    size: width * 0.5,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-small.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(width * 0.075, width * 0.075),
                    ),
                    backgroundColor: DefaultTheme.WHITE,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  'Tên chủ TK: ${bankAccountDTO.bankAccountName.toUpperCase()}',
                  style: const TextStyle(
                    color: DefaultTheme.BLUE_DARK,
                    fontSize: 15,
                  ),
                ),
                //Số tài khoản
                Text(
                  'Số TK: ${BankInformationUtil.instance.hideBankAccount(bankAccountDTO.bankAccount)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: DefaultTheme.BLUE_DARK,
                    fontSize: 15,
                  ),
                ),
                //Tên ngân hàng
                Text(
                  bankAccountDTO.bankName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DefaultTheme.BLUE_DARK,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
