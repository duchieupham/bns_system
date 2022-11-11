import 'package:check_sms/commons/utils/time_utils.dart';
import 'package:check_sms/features/generate_qr/views/qr_generator.dart';
import 'package:check_sms/features/home/theme_setting.dart';
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
  Map<String, List<SmsMessage>> messagesByAddr = {};

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
      print('----on msg: ${msg.address} - ${msg.body}');
      var snackBar = SnackBar(
        content: Text(
          msg.body.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    //

    messages = await query.getAllSms;
    if (messages.isNotEmpty) {
      for (int i = 0; i < messages.length; i++) {
        // print(
        //     '---message $i: id: ${messages[i].id} - address: ${messages[i].address} - msg: ${messages[i].body} - date sent: ${messages[i].dateSent}');
        if (messagesByAddr.containsKey(messages[i].address)) {
          messagesByAddr[messages[i].address]!.add(
            messages[i],
          );
        } else {
          messagesByAddr[messages[i].address ?? ''] = [];
          messagesByAddr[messages[i].address]!.add(
            messages[i],
          );
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // Container(
        //   width: width,
        //   alignment: Alignment.center,
        //   height: 300,
        //   child: QrImage(
        //     data:
        //         '00020101021238570010A00000072701270006970403011300110123456780208QRIBFTTA530370454061800005802VN62340107NPS68690819thanh toan don hang63042E2E',
        //     // data:
        //     //     "00020101021138540010A00000072701240006970422011011233555890208QRIBFTTA53037045802VN6304866E",
        //     version: QrVersions.auto,
        //     size: 300.0,
        //   ),
        // ),
        Expanded(
          child: Visibility(
            visible: messagesByAddr.isNotEmpty,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: messagesByAddr.length,
              padding: const EdgeInsets.only(left: 10, right: 10),
              itemBuilder: ((context, index) {
                return Container(
                  width: width,
                  height: 120,
                  margin: EdgeInsets.only(
                      top: 10,
                      bottom: (index == messagesByAddr.length - 1) ? 100 : 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25)),
                        margin: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messagesByAddr.values
                                  .elementAt(index)
                                  .first
                                  .address
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              messagesByAddr.values
                                  .elementAt(index)
                                  .first
                                  .body
                                  .toString(),
                              style: const TextStyle(color: Colors.grey),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.2,
                        alignment: Alignment.centerRight,
                        child: Text(
                          TimeUtils.instance.formatHour(messagesByAddr.values
                              .elementAt(index)
                              .first
                              .dateSent
                              .toString()),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
