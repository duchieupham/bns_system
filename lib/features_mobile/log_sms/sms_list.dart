import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
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
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/services/firestore/bank_account_db.dart';
import 'package:vierqr/services/firestore/transaction_db.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

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

    msgStream.listen((msg) async {
      if (BankInformationUtil.instance
          .checkBankAddress(msg.address.toString())) {
        if (BankInformationUtil.instance
            .checkAvailableAddress(msg.address.toString())) {
          DialogWidget.instance.openTransactionFormattedDialog(
            context,
            msg.address.toString(),
            msg.body.toString(),
            TimeUtils.instance.formatTime(msg.date.toString()),
          );
          //
          final BankInformationDTO bankInformationDTO =
              SmsInformationUtils.instance.transferSmsData(
            BankInformationUtil.instance.getBankName(msg.address.toString()),
            msg.body.toString(),
            msg.date.toString(),
          );
          String bankId = await BankAccountDB.instance.getBankIdByAccount(
              UserInformationHelper.instance.getUserId(),
              bankInformationDTO.bankAccount);

          const Uuid uuid = Uuid();
          final TransactionDTO transactionDTO = TransactionDTO(
            id: uuid.v1(),
            accountBalance: bankInformationDTO.accountBalance,
            address: bankInformationDTO.address,
            bankAccount: bankInformationDTO.bankAccount,
            bankId: bankId,
            content: bankInformationDTO.content,
            isFormatted: true,
            status: 'PAID',
            timeInserted: FieldValue.serverTimestamp(),
            timeReceived: bankInformationDTO.time,
            transaction: bankInformationDTO.transaction,
            type: 'SMS',
            userId: UserInformationHelper.instance.getUserId(),
          );
          await TransactionDB.instance.insertTransaction(transactionDTO);
        } else {
          DialogWidget.instance.openTransactionDialog(
            context,
            msg.address.toString(),
            msg.body.toString(),
          );
          const Uuid uuid = Uuid();
          final TransactionDTO transactionDTO = TransactionDTO(
            id: uuid.v1(),
            accountBalance: '',
            address: msg.address.toString(),
            bankAccount: '',
            bankId: '',
            content: msg.body.toString(),
            isFormatted: false,
            status: 'PAID',
            timeInserted: FieldValue.serverTimestamp(),
            timeReceived: '',
            transaction: '',
            type: 'SMS',
            userId: UserInformationHelper.instance.getUserId(),
          );
          await TransactionDB.instance.insertTransaction(transactionDTO);
        }
      }
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

      setState(() {});
    });
    //
    messagesByAddr = await smsRepository.getListMessage();
    setState(() {});

    ///FOR TESTING
    ///
    // if (!ScreenResolutionUtils.instance.isWeb()) {
    //   //MSG 1
    //   await Future.delayed(const Duration(seconds: 10), () async {
    //     print('after 10 seconds');
    //     Map<String, dynamic> data = {
    //       'id': 1,
    //       'threadId': 1,
    //       'address': '0900000000',
    //       'body':
    //           'VietinBank:21/01/2022 11:35|TK:115000067275|GD:-4,400,000VND|SDC:352,694,458VND|ND:So GD: 124A2210XKCSDB6FBPO7426. 1 BPO8114.1 Bluecom thanh toan 100 hoa don 00000133 ~',
    //       'read': false,
    //       'date': '21/01/2022 11:37',
    //       'dateSent': '21/01/2022 11:37',
    //       'kind': SmsMessageKind.received,
    //     };
    //     if (BankInformationUtil.instance
    //         .checkBankAddress(data['address'].toString())) {
    //       if (BankInformationUtil.instance
    //           .checkAvailableAddress(data['address'].toString())) {
    //         DialogWidget.instance.openTransactionFormattedDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //           TimeUtils.instance.formatTime(data['date'].toString()),
    //         );

    //         final BankInformationDTO bankInformationDTO =
    //             SmsInformationUtils.instance.transferSmsData(
    //           BankInformationUtil.instance.getBankName(data['address']),
    //           data['body'],
    //           data['date'],
    //         );
    //         String bankId = await BankAccountDB.instance.getBankIdByAccount(
    //             UserInformationHelper.instance.getUserId(),
    //             bankInformationDTO.bankAccount);
    //         print('--------BankID: $bankId');
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: bankInformationDTO.accountBalance,
    //           address: bankInformationDTO.address,
    //           bankAccount: bankInformationDTO.bankAccount,
    //           bankId: bankId,
    //           content: bankInformationDTO.content,
    //           isFormatted: true,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: bankInformationDTO.time,
    //           transaction: bankInformationDTO.transaction,
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //       } else {
    //         DialogWidget.instance.openTransactionDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //         );
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: '',
    //           address: data['address'],
    //           bankAccount: '',
    //           bankId: '',
    //           content: data['body'],
    //           isFormatted: false,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: '',
    //           transaction: '',
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //       }
    //     }
    //     MessageDTO dto = MessageDTO(
    //         id: data['id'] ?? 0,
    //         threadId: data['threadId'] ?? 0,
    //         address: data['address'] ?? '',
    //         body: data['body'] ?? '',
    //         date: data['date'].toString(),
    //         dateSent: data['dateSent'].toString(),
    //         read: data['read'] ?? false);
    //     if (messagesByAddr.containsKey(data['address'])) {
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     } else {
    //       messagesByAddr[data['address'] ?? ''] = [];
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     }
    //     setState(() {});
    //   });
    //   //MSG 2
    //   await Future.delayed(const Duration(seconds: 10), () async {
    //     print('after 20 seconds');
    //     Map<String, dynamic> data = {
    //       'id': 234,
    //       'threadId': 1123,
    //       'address': '0909999999',
    //       'body':
    //           'SDTK 1000006789 den 17:56:38 ngay 13/11/2022 la 8,668,033 VND. GD moi nhat: +2,500,000 VND: PHAM DUC TUAN  CHUYEN KHOAN Pham duc Trong quang 0936382222',
    //       'read': false,
    //       'date': '21/01/2022 11:40',
    //       'dateSent': '21/01/2022 11:40',
    //       'kind': SmsMessageKind.received,
    //     };
    //     if (BankInformationUtil.instance
    //         .checkBankAddress(data['address'].toString())) {
    //       if (BankInformationUtil.instance
    //           .checkAvailableAddress(data['address'].toString())) {
    //         DialogWidget.instance.openTransactionFormattedDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //           TimeUtils.instance.formatTime(data['date'].toString()),
    //         );

    //         final BankInformationDTO bankInformationDTO =
    //             SmsInformationUtils.instance.transferSmsData(
    //           BankInformationUtil.instance.getBankName(data['address']),
    //           data['body'],
    //           data['date'],
    //         );
    //         String bankId = await BankAccountDB.instance.getBankIdByAccount(
    //             UserInformationHelper.instance.getUserId(),
    //             bankInformationDTO.bankAccount);
    //         print('--------BankID: $bankId');
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: bankInformationDTO.accountBalance,
    //           address: bankInformationDTO.address,
    //           bankAccount: bankInformationDTO.bankAccount,
    //           bankId: bankId,
    //           content: bankInformationDTO.content,
    //           isFormatted: true,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: bankInformationDTO.time,
    //           transaction: bankInformationDTO.transaction,
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //         if (bankId.isNotEmpty) {
    //           //
    //         } else {
    //           //
    //         }
    //       } else {
    //         DialogWidget.instance.openTransactionDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //         );
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: '',
    //           address: data['address'],
    //           bankAccount: '',
    //           bankId: '',
    //           content: data['body'],
    //           isFormatted: false,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: '',
    //           transaction: '',
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //       }
    //     }
    //     MessageDTO dto = MessageDTO(
    //         id: data['id'] ?? 0,
    //         threadId: data['threadId'] ?? 0,
    //         address: data['address'] ?? '',
    //         body: data['body'] ?? '',
    //         date: data['date'].toString(),
    //         dateSent: data['dateSent'].toString(),
    //         read: data['read'] ?? false);
    //     if (messagesByAddr.containsKey(data['address'])) {
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     } else {
    //       messagesByAddr[data['address'] ?? ''] = [];
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     }
    //     setState(() {});
    //   });
    //   //MSG 3
    //   await Future.delayed(const Duration(seconds: 10), () async {
    //     print('after 30 seconds');
    //     Map<String, dynamic> data = {
    //       'id': 234,
    //       'threadId': 1123,
    //       'address': '0909090901',
    //       'body':
    //           'TK 49182391234 NGAY 23/09/22 13:59 SD DAU 46,554,832 TANG 46,500,000 SD CUOI 54,832 VND (CHUYEN KHOAN TU TAI KHOAN 49182391234)',
    //       'read': false,
    //       'date': '21/01/2022 11:40',
    //       'dateSent': '21/01/2022 11:40',
    //       'kind': SmsMessageKind.received,
    //     };
    //     if (BankInformationUtil.instance
    //         .checkBankAddress(data['address'].toString())) {
    //       if (BankInformationUtil.instance
    //           .checkAvailableAddress(data['address'].toString())) {
    //         DialogWidget.instance.openTransactionFormattedDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //           TimeUtils.instance.formatTime(data['date'].toString()),
    //         );

    //         final BankInformationDTO bankInformationDTO =
    //             SmsInformationUtils.instance.transferSmsData(
    //           BankInformationUtil.instance.getBankName(data['address']),
    //           data['body'],
    //           data['date'],
    //         );
    //         String bankId = await BankAccountDB.instance.getBankIdByAccount(
    //             UserInformationHelper.instance.getUserId(),
    //             bankInformationDTO.bankAccount);
    //         print('--------BankID: $bankId');
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: bankInformationDTO.accountBalance,
    //           address: bankInformationDTO.address,
    //           bankAccount: bankInformationDTO.bankAccount,
    //           bankId: bankId,
    //           content: bankInformationDTO.content,
    //           isFormatted: true,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: bankInformationDTO.time,
    //           transaction: bankInformationDTO.transaction,
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //         if (bankId.isNotEmpty) {
    //           //
    //         } else {
    //           //
    //         }
    //       } else {
    //         DialogWidget.instance.openTransactionDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //         );
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: '',
    //           address: data['address'],
    //           bankAccount: '',
    //           bankId: '',
    //           content: data['body'],
    //           isFormatted: false,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: '',
    //           transaction: '',
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //       }
    //     }
    //     MessageDTO dto = MessageDTO(
    //         id: data['id'] ?? 0,
    //         threadId: data['threadId'] ?? 0,
    //         address: data['address'] ?? '',
    //         body: data['body'] ?? '',
    //         date: data['date'].toString(),
    //         dateSent: data['dateSent'].toString(),
    //         read: data['read'] ?? false);
    //     if (messagesByAddr.containsKey(data['address'])) {
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     } else {
    //       messagesByAddr[data['address'] ?? ''] = [];
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     }
    //     setState(() {});
    //   });
    //   //MSG4
    //   await Future.delayed(const Duration(seconds: 10), () async {
    //     print('after 30 seconds');
    //     Map<String, dynamic> data = {
    //       'id': 234,
    //       'threadId': 1123,
    //       'address': 'TPBANK',
    //       'body': 'Example unformatted content.',
    //       'read': false,
    //       'date': '',
    //       'dateSent': '',
    //       'kind': SmsMessageKind.received,
    //     };
    //     if (BankInformationUtil.instance
    //         .checkBankAddress(data['address'].toString())) {
    //       if (BankInformationUtil.instance
    //           .checkAvailableAddress(data['address'].toString())) {
    //         DialogWidget.instance.openTransactionFormattedDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //           TimeUtils.instance.formatTime(data['date'].toString()),
    //         );

    //         final BankInformationDTO bankInformationDTO =
    //             SmsInformationUtils.instance.transferSmsData(
    //           BankInformationUtil.instance.getBankName(data['address']),
    //           data['body'],
    //           data['date'],
    //         );
    //         String bankId = await BankAccountDB.instance.getBankIdByAccount(
    //             UserInformationHelper.instance.getUserId(),
    //             bankInformationDTO.bankAccount);
    //         print('--------BankID: $bankId');
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: bankInformationDTO.accountBalance,
    //           address: bankInformationDTO.address,
    //           bankAccount: bankInformationDTO.bankAccount,
    //           bankId: bankId,
    //           content: bankInformationDTO.content,
    //           isFormatted: true,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: bankInformationDTO.time,
    //           transaction: bankInformationDTO.transaction,
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //         if (bankId.isNotEmpty) {
    //           //
    //         } else {
    //           //
    //         }
    //       } else {
    //         DialogWidget.instance.openTransactionDialog(
    //           context,
    //           data['address'].toString(),
    //           data['body'].toString(),
    //         );
    //         const Uuid uuid = Uuid();
    //         final TransactionDTO transactionDTO = TransactionDTO(
    //           id: uuid.v1(),
    //           accountBalance: '',
    //           address: data['address'],
    //           bankAccount: '',
    //           bankId: '',
    //           content: data['body'],
    //           isFormatted: false,
    //           status: 'PAID',
    //           timeInserted: FieldValue.serverTimestamp(),
    //           timeReceived: '',
    //           transaction: '',
    //           type: 'SMS',
    //           userId: UserInformationHelper.instance.getUserId(),
    //         );
    //         await TransactionDB.instance.insertTransaction(transactionDTO);
    //       }
    //     }
    //     MessageDTO dto = MessageDTO(
    //         id: data['id'] ?? 0,
    //         threadId: data['threadId'] ?? 0,
    //         address: data['address'] ?? '',
    //         body: data['body'] ?? '',
    //         date: data['date'].toString(),
    //         dateSent: data['dateSent'].toString(),
    //         read: data['read'] ?? false);
    //     if (messagesByAddr.containsKey(data['address'])) {
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     } else {
    //       messagesByAddr[data['address'] ?? ''] = [];
    //       messagesByAddr[data['address']]!.insert(0, dto);
    //     }
    //     setState(() {});
    //   });
    // }
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
