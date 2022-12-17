import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/sms_information_utils.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/commons/widgets/avatar_text_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';

import 'package:vierqr/features_mobile/log_sms/blocs/sms_bloc.dart';
import 'package:vierqr/features_mobile/log_sms/blocs/transaction_bloc.dart';
import 'package:vierqr/features_mobile/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features_mobile/log_sms/events/sms_event.dart';
import 'package:vierqr/features_mobile/log_sms/events/transaction_event.dart';
import 'package:vierqr/features_mobile/notification/events/notification_event.dart';

import 'package:vierqr/features_mobile/log_sms/sms_detail.dart';
import 'package:vierqr/features_mobile/log_sms/states/sms_state.dart';
import 'package:vierqr/features_mobile/log_sms/states/transaction_state.dart';
import 'package:vierqr/features_mobile/log_sms/widgets/sms_list_item.dart';
import 'package:vierqr/models/bank_information_dto.dart';
import 'package:vierqr/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SMSList extends StatelessWidget {
  static final Map<String, List<MessageDTO>> messagesByAddr = {};
  static late SMSBloc _smsBloc;
  static late TransactionBloc _transactionBloc;
  static late NotificationBloc _notificationBloc;
  static bool isListened = false;

  const SMSList({Key? key}) : super(key: key);

  initialServices(BuildContext context) {
    _smsBloc = BlocProvider.of(context);
    _transactionBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _smsBloc.add(const SMSEventGetList());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: BlocConsumer<SMSBloc, SMSState>(
        listener: ((context, state) {
          if (state is SMSSuccessfulListState) {
            messagesByAddr.clear();
            if (!isListened) {
              _smsBloc.add(SMSEventListen(
                smsBloc: _smsBloc,
                userId: UserInformationHelper.instance.getUserId(),
              ));
              isListened = true;
            }
            if (messagesByAddr.isEmpty && state.messages.isNotEmpty) {
              messagesByAddr.addAll(state.messages);
            }
          }
          if (state is SMSReceivedState) {
            if (messagesByAddr.containsKey(state.messageDTO.address)) {
              messagesByAddr[state.messageDTO.address]!
                  .insert(0, state.messageDTO);
            } else {
              messagesByAddr[state.messageDTO.address] = [];
              messagesByAddr[state.messageDTO.address]!
                  .insert(0, state.messageDTO);
            }
            if (BankInformationUtil.instance
                .checkAvailableAddress(state.messageDTO.address)) {
              DialogWidget.instance.openTransactionFormattedDialog(
                context,
                state.messageDTO.address,
                state.messageDTO.body,
                state.messageDTO.date,
              );
            } else {
              DialogWidget.instance.openTransactionDialog(
                context,
                state.messageDTO.address,
                state.messageDTO.body,
              );
            }
            _transactionBloc.add(
                TransactionEventInsert(transactionDTO: state.transactionDTO));
          }
        }),
        builder: (context, state) {
          if (state is SMSSuccessfulListState) {
            if (state.messages.isEmpty) {
              messagesByAddr.clear();
            }
          }
          return BlocConsumer<TransactionBloc, TransactionState>(
            listener: ((context, state) {
              if (state is TransactionInsertSuccessState) {
                //insert transaction - notification here
                _notificationBloc.add(NotificationEventInsert(
                  bankId: state.bankId,
                  transactionId: state.transactionId,
                  timeInserted: state.timeInserted,
                  address: state.address,
                  transaction: state.transaction,
                ));
              }
            }),
            builder: ((context, state) {
              return Visibility(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Text(
                                          messagesByAddr.values
                                              .elementAt(index)
                                              .first
                                              .body
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.grey),
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
                                      TimeUtils.instance.formatHour(
                                          messagesByAddr.values
                                              .elementAt(index)
                                              .first
                                              .date
                                              .toString()),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  }),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
