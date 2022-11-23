import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:check_sms/commons/utils/sms_information_utils.dart';
import 'package:check_sms/models/bank_information_dto.dart';
import 'package:flutter/material.dart';

class SmsDetailItem extends StatelessWidget {
  final BankInformationDTO bankInforDTO;
  const SmsDetailItem({
    Key? key,
    required this.bankInforDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankInforDTO.time,
            style: TextStyle(color: DefaultTheme.GREY_TEXT),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: (BankInformationUtil.instance
                      .isIncome(bankInforDTO.transaction))
                  ? DefaultTheme.GREEN.withOpacity(0.3)
                  : DefaultTheme.RED_TEXT.withOpacity(0.3),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: width,
                  child: Text(
                    bankInforDTO.transaction,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: BankInformationUtil.instance
                              .isIncome(bankInforDTO.transaction)
                          ? DefaultTheme.GREEN
                          : DefaultTheme.RED_TEXT,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                SizedBox(
                  width: width,
                  child: Text(
                    'Tài khoản: ${bankInforDTO.bankAccount}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                SizedBox(
                  width: width,
                  child: Text(
                    'Số dư: ${bankInforDTO.accountBalance}',
                    style: TextStyle(
                      fontSize: 15,
                      color: BankInformationUtil.instance
                              .isIncome(bankInforDTO.transaction)
                          ? DefaultTheme.GREEN
                          : DefaultTheme.RED_TEXT,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                SizedBox(
                  width: width,
                  child: Text(
                    'Nội dung:\n${bankInforDTO.content}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
