import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart' as smslistener;
import 'package:rxdart/rxdart.dart';

class SmsRepository {
  static final smsListenController = BehaviorSubject<dynamic>();

  SmsRepository();

  //
  Future<Map<String, List<MessageDTO>>> getListMessage() async {
    Map<String, List<MessageDTO>> result = {};
    try {
      final SmsQuery query = SmsQuery();
      await Permission.sms.request();
      List<SmsMessage> messages = await query.getAllSms;
      if (messages.isNotEmpty) {
        for (int i = 0; i < messages.length; i++) {
          if (BankInformationUtil.instance
              .checkBankAddress(messages[i].address.toString())) {
            MessageDTO dto = MessageDTO(
                id: messages[i].id ?? 0,
                threadId: messages[i].threadId ?? 0,
                address: messages[i].address ?? '',
                body: messages[i].body ?? '',
                date: messages[i].date.toString(),
                dateSent: messages[i].dateSent.toString(),
                read: messages[i].read ?? false);
            // print(
            //     '---message $i: id: ${messages[i].id} - address: ${messages[i].address} - msg: ${messages[i].body} - date sent: ${messages[i].dateSent}');
            if (result.containsKey(messages[i].address)) {
              result[messages[i].address]!.add(
                dto,
              );
            } else {
              result[messages[i].address ?? ''] = [];
              result[messages[i].address]!.add(
                dto,
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error at getListMessage - SmsRepository: $e');
    }
    return result;
  }

  Future<void> listenNewSMS() async {
    try {} catch (e) {
      print('Error at listenNewSMS - SmsRepository: $e');
    }
  }
}
