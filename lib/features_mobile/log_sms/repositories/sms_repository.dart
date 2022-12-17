import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart' as smslistener;
import 'package:rxdart/rxdart.dart';

class SmsRepository {
  static final smsListenController = BehaviorSubject<MessageDTO>();

  const SmsRepository();

  //step 1
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

  //step 1
  Future<void> listenNewSMS() async {
    try {
      smslistener.FlutterSmsListener smsListener =
          smslistener.FlutterSmsListener();
      smsListener.onSmsReceived!.listen((msg) {
        //some address bank maybe not match with these existed addresses.
        if (BankInformationUtil.instance
            .checkBankAddress(msg.address.toString())) {
          MessageDTO messageDTO = MessageDTO(
              id: msg.id ?? 0,
              threadId: msg.threadId ?? 0,
              address: msg.address ?? '',
              body: msg.body ?? '',
              date: msg.date.toString(),
              dateSent: msg.dateSent.toString(),
              read: msg.read ?? false);
          smsListenController.sink.add(messageDTO);
        }
      });

      //TEST
      if (!ScreenResolutionUtils.instance.isWeb()) {
        //MSG 1
        await Future.delayed(const Duration(seconds: 10), () async {
          print('msg 1 after 10 seconds');
          Map<String, dynamic> data = {
            'id': 1,
            'threadId': 1,
            'address': '0900000000',
            'body':
                'VietinBank:21/01/2022 11:35|TK:115000067275|GD:-4,400,000VND|SDC:352,694,458VND|ND:So GD: 124A2210XKCSDB6FBPO7426. 1 BPO8114.1 Bluecom thanh toan 100 hoa don 00000133 ~',
            'read': false,
            'date': '21/01/2022 11:37',
            'dateSent': '21/01/2022 11:37',
            'kind': SmsMessageKind.received,
          };
          MessageDTO dto = MessageDTO(
              id: data['id'] ?? 0,
              threadId: data['threadId'] ?? 0,
              address: data['address'] ?? '',
              body: data['body'] ?? '',
              date: data['date'].toString(),
              dateSent: data['dateSent'].toString(),
              read: data['read'] ?? false);
          smsListenController.sink.add(dto);
        });
        //MSG 2
        await Future.delayed(const Duration(seconds: 10), () async {
          print('msg 2 after 20 seconds');
          Map<String, dynamic> data = {
            'id': 234,
            'threadId': 1123,
            'address': '0909999999',
            'body':
                'SDTK 1000006789 den 17:56:38 ngay 13/11/2022 la 8,668,033 VND. GD moi nhat: +2,500,000 VND: PHAM DUC TUAN  CHUYEN KHOAN Pham duc Trong quang 0936382222',
            'read': false,
            'date': '21/01/2022 11:40',
            'dateSent': '21/01/2022 11:40',
            'kind': SmsMessageKind.received,
          };

          MessageDTO dto = MessageDTO(
              id: data['id'] ?? 0,
              threadId: data['threadId'] ?? 0,
              address: data['address'] ?? '',
              body: data['body'] ?? '',
              date: data['date'].toString(),
              dateSent: data['dateSent'].toString(),
              read: data['read'] ?? false);
          smsListenController.sink.add(dto);
        });
        //MSG 3
        await Future.delayed(const Duration(seconds: 10), () async {
          print('msg 3 after 30 seconds');
          Map<String, dynamic> data = {
            'id': 234,
            'threadId': 1123,
            'address': '0909090901',
            'body':
                'TK 49182391234 NGAY 23/09/22 13:59 SD DAU 46,554,832 TANG 46,500,000 SD CUOI 54,832 VND (CHUYEN KHOAN TU TAI KHOAN 49182391234)',
            'read': false,
            'date': '21/01/2022 11:40',
            'dateSent': '21/01/2022 11:40',
            'kind': SmsMessageKind.received,
          };

          MessageDTO dto = MessageDTO(
              id: data['id'] ?? 0,
              threadId: data['threadId'] ?? 0,
              address: data['address'] ?? '',
              body: data['body'] ?? '',
              date: data['date'].toString(),
              dateSent: data['dateSent'].toString(),
              read: data['read'] ?? false);
          smsListenController.sink.add(dto);
        });
        //MSG4
        await Future.delayed(const Duration(seconds: 10), () async {
          print('msg 4 after 30 seconds');
          Map<String, dynamic> data = {
            'id': 234,
            'threadId': 1123,
            'address': 'TPBANK',
            'body': 'Example unformatted content.',
            'read': false,
            'date': '',
            'dateSent': '',
            'kind': SmsMessageKind.received,
          };

          MessageDTO dto = MessageDTO(
              id: data['id'] ?? 0,
              threadId: data['threadId'] ?? 0,
              address: data['address'] ?? '',
              body: data['body'] ?? '',
              date: data['date'].toString(),
              dateSent: data['dateSent'].toString(),
              read: data['read'] ?? false);
          smsListenController.sink.add(dto);
        });
      }
    } catch (e) {
      print('Error at listenNewSMS - SmsRepository: $e');
    }
  }
}
