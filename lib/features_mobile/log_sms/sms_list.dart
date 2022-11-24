import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/sms_information_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/avatar_text_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features_mobile/log_sms/repositories/sms_repository.dart';
import 'package:vierqr/features_mobile/log_sms/sms_detail.dart';
import 'package:vierqr/features_mobile/log_sms/widgets/sms_list_item.dart';
import 'package:vierqr/models/bank_information_dto.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart' as smslistener;
import 'package:permission_handler/permission_handler.dart';

class SMSList extends StatefulWidget {
  const SMSList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SMSList();
}

class _SMSList extends State<SMSList> {
  late SmsQuery query;

  List<SmsMessage> messages = [];
  Map<String, List<MessageDTO>> messagesByAddr = {};

  SmsRepository smsRepository = SmsRepository();

  @override
  initState() {
    super.initState();
    query = SmsQuery();
    getSMS();
  }

  Future<void> getSMS() async {
    await Permission.sms.request();
    //
    smslistener.FlutterSmsListener smsListener =
        smslistener.FlutterSmsListener();

    Stream<smslistener.SmsMessage> msgStream = smsListener.onSmsReceived!;
    msgStream.listen((msg) {
      if (BankInformationUtil.instance
          .checkBankAddress(msg.address.toString())) {
        DialogWidget.instance.openTransactionFormattedDialog(
          context,
          msg.address.toString(),
          msg.body.toString(),
          TimeUtils.instance.formatTime(msg.date.toString()),
        );
        MessageDTO dto = MessageDTO(
            id: msg.id ?? 0,
            threadId: msg.threadId ?? 0,
            address: msg.address ?? '',
            body: msg.body ?? '',
            date: msg.date.toString(),
            dateSent: msg.dateSent.toString(),
            read: msg.read ?? false);
        if (messagesByAddr.containsKey(msg.address)) {
          messagesByAddr[msg.address]!.insert(0, dto);
        } else {
          messagesByAddr[msg.address ?? ''] = [];
          messagesByAddr[msg.address]!.insert(0, dto);
        }
      } else {
        DialogWidget.instance.openTransactionDialog(
          context,
          msg.address.toString(),
          msg.body.toString(),
        );
      }

      setState(() {});
    });
    //

    messagesByAddr = await smsRepository.getListMessage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Visibility(
              visible: messagesByAddr.isNotEmpty,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messagesByAddr.length,
                padding: const EdgeInsets.only(left: 10, right: 10),
                itemBuilder: ((context, index) {
                  bool isFormatData = false;
                  String address = messagesByAddr.values
                      .elementAt(index)
                      .first
                      .address
                      .toString();
                  String body = messagesByAddr.values
                      .elementAt(index)
                      .first
                      .body
                      .toString();
                  String date = messagesByAddr.values
                      .elementAt(index)
                      .first
                      .date
                      .toString();
                  BankInformationDTO dto = const BankInformationDTO(
                      address: '',
                      time: '',
                      transaction: '',
                      accountBalance: '',
                      content: '',
                      bankAccount: '');
                  if (BankInformationUtil.instance
                      .checkAvailableAddress(address)) {
                    isFormatData = true;
                    dto = SmsInformationUtils.instance.transferSmsData(
                      BankInformationUtil.instance.getBankName(address),
                      body,
                      TimeUtils.instance.formatTime(date),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SmsDetailScreen(
                            address: address,
                            messages: messagesByAddr.values.elementAt(index),
                            isFormatData: isFormatData,
                          ),
                        ),
                      );
                    },
                    child: (isFormatData)
                        ? SMSListItem(bankInforDTO: dto)
                        : Container(
                            width: width,
                            margin: EdgeInsets.only(
                                top: 10,
                                bottom: (index == messagesByAddr.length - 1)
                                    ? 100
                                    : 0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                AvatarTextWidget(
                                  size: 50,
                                  text: messagesByAddr.values
                                      .elementAt(index)
                                      .first
                                      .address
                                      .toString(),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messagesByAddr.values
                                            .elementAt(index)
                                            .first
                                            .address
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Text(
                                        messagesByAddr.values
                                            .elementAt(index)
                                            .first
                                            .body
                                            .toString(),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.2,
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    TimeUtils.instance.formatHour(messagesByAddr
                                        .values
                                        .elementAt(index)
                                        .first
                                        .date
                                        .toString()),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
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
