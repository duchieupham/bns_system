import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/bank_information_utils.dart';
import 'package:check_sms/commons/utils/sms_information_utils.dart';
import 'package:check_sms/commons/utils/time_utils.dart';
import 'package:check_sms/commons/widgets/sub_header_widget.dart';
import 'package:check_sms/features/log_sms/widgets/sms_detail_item.dart';
import 'package:check_sms/models/bank_information_dto.dart';
import 'package:check_sms/models/message_dto.dart';
import 'package:flutter/material.dart';

class SmsDetailScreen extends StatefulWidget {
  final String address;
  final List<MessageDTO> messages;
  final bool isFormatData;

  SmsDetailScreen({
    Key? key,
    required this.address,
    required this.messages,
    required this.isFormatData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmsDetailScreen();
}

class _SmsDetailScreen extends State<SmsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          SubHeader(title: widget.address),
          Visibility(
            visible: widget.messages.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: ((context, index) {
                  BankInformationDTO dto = const BankInformationDTO(
                      address: '',
                      time: '',
                      transaction: '',
                      accountBalance: '',
                      content: '',
                      bankAccount: '');
                  String address = widget.messages[index].address;
                  String body = widget.messages[index].body;
                  String date = widget.messages[index].date;
                  if (widget.isFormatData) {
                    dto = SmsInformationUtils.instance.transferSmsData(
                      BankInformationUtil.instance.getBankName(address),
                      body,
                      TimeUtils.instance.formatTime(date),
                    );
                  }
                  return (widget.isFormatData)
                      ? SmsDetailItem(bankInforDTO: dto)
                      : Container(
                          margin: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  widget.messages[index].body.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                '\t${TimeUtils.instance.formatHour2(widget.messages[index].date.toString())}',
                                style: const TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                ),
                              ),
                            ],
                          ),
                        );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
