import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:check_sms/commons/widgets/avatar_text_widget.dart';
import 'package:check_sms/models/bank_information_dto.dart';
import 'package:flutter/material.dart';

class SMSListItem extends StatelessWidget {
  final BankInformationDTO bankInforDTO;

  const SMSListItem({
    Key? key,
    required this.bankInforDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarTextWidget(size: 50, text: bankInforDTO.address),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).hintColor,
                    ),
                    children: [
                      TextSpan(
                        text: '${bankInforDTO.address}\n',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: bankInforDTO.time,
                        style: const TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Text(
              bankInforDTO.transaction,
              style: TextStyle(
                color: (BankInformationUtil.instance
                        .isIncome(bankInforDTO.transaction))
                    ? DefaultTheme.GREEN
                    : DefaultTheme.RED_TEXT,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, top: 5),
            child: Text(
              'Số dư: ${bankInforDTO.accountBalance}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
