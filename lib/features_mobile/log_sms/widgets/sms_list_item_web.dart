import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/transaction_dto.dart';

class SMSListItemWeb extends StatelessWidget {
  final TransactionDTO transactionDTO;

  const SMSListItemWeb({super.key, required this.transactionDTO});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: (transactionDTO.isFormatted)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TimeUtils.instance.formatDateFromTimeStamp(
                    transactionDTO.timeInserted,
                    false,
                  ),
                  style: const TextStyle(color: DefaultTheme.GREY_TEXT),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (BankInformationUtil.instance
                            .isIncome(transactionDTO.transaction))
                        ? DefaultTheme.GREEN.withOpacity(0.3)
                        : DefaultTheme.RED_TEXT.withOpacity(0.3),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: Text(
                          transactionDTO.address,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width,
                        child: Text(
                          transactionDTO.transaction,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: BankInformationUtil.instance
                                    .isIncome(transactionDTO.transaction)
                                ? DefaultTheme.GREEN
                                : DefaultTheme.RED_TEXT,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width,
                        child: Text(
                          'Tài khoản: ${transactionDTO.bankAccount}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width,
                        child: Text(
                          'Số dư: ${transactionDTO.accountBalance}',
                          style: TextStyle(
                            fontSize: 13,
                            color: BankInformationUtil.instance
                                    .isIncome(transactionDTO.transaction)
                                ? DefaultTheme.GREEN
                                : DefaultTheme.RED_TEXT,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      SizedBox(
                        width: width,
                        child: Text(
                          'Nội dung:\n${transactionDTO.content}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionDTO.timeReceived,
                  style: const TextStyle(color: DefaultTheme.GREY_TEXT),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                SizedBox(
                  width: width,
                  child: Text(
                    'Nội dung:\n${transactionDTO.content}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
    );
  }
}
