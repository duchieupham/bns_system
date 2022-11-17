import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:flutter/material.dart';

class BankCardWidget extends StatelessWidget {
  final BankAccountDTO bankAccountDTO;
  final bool? isRemove;
  final VoidCallback? function;

  const BankCardWidget({
    Key? key,
    required this.bankAccountDTO,
    this.isRemove,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: (width < 400) ? width : 400,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DefaultTheme.BANK_CARD_COLOR_1,
            DefaultTheme.BANK_CARD_COLOR_2,
            DefaultTheme.BANK_CARD_COLOR_3,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //need to add remove function
          Text(
            bankAccountDTO.bankCode,
            style: const TextStyle(
              color: DefaultTheme.GREY_TEXT,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            bankAccountDTO.bankName,
            style: const TextStyle(
              color: DefaultTheme.BLACK,
              fontSize: 16,
              fontFamily: 'TimesNewRoman',
            ),
          ),
          const Spacer(),
          Text(
            bankAccountDTO.bankAccount,
            style: const TextStyle(
              color: DefaultTheme.WHITE,
              fontSize: 30,
              letterSpacing: 2.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'TimesNewRoman',
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          Text(
            bankAccountDTO.bankAccountName.toUpperCase(),
            style: const TextStyle(
              color: DefaultTheme.BLACK,
              fontSize: 16,
              fontFamily: 'TimesNewRoman',
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
  }
}
