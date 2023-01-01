import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
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
import 'package:flutter/material.dart';
import 'package:vierqr/features_mobile/notification/states/notification_state.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SMSList extends StatelessWidget {
  // static final Map<String, List<MessageDTO>> messagesByAddr = {};
  static final Map<String, List<TransactionDTO>> transactionByAddr = {};
  static late SMSBloc _smsBloc;
  static late TransactionBloc _transactionBloc;
  static late NotificationBloc _notificationBloc;

  const SMSList({Key? key}) : super(key: key);

  initialServices(BuildContext context) async {
    String userId = UserInformationHelper.instance.getUserId();
    _transactionBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _smsBloc = BlocProvider.of(context);
    _transactionBloc.add(TransactionEventGetList(userId: userId));
    //android process
    if (PlatformUtils.instance.isAndroidApp(context)) {
      if (PlatformUtils.instance.isAndroidApp(context)) {
        _smsBloc.add(const SMSEventGetList());
        if (!EventBlocHelper.instance.isListenedSMS()) {
          _smsBloc.add(SMSEventListen(
            smsBloc: _smsBloc,
            userId: userId,
          ));
          await EventBlocHelper.instance.updateListenSMS(true);
        }
      }
    }
    if (!EventBlocHelper.instance.isListenedNotification()) {
      _notificationBloc.add(NotificationEventListen(
          userId: userId, notificationBloc: _notificationBloc));
      await EventBlocHelper.instance.updateListenNotification(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    initialServices(context);
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: (PlatformUtils.instance.isAndroidApp(context))
          ? BlocListener<SMSBloc, SMSState>(
              listener: ((context, state) {
                if (state is SMSReceivedState) {
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
                  _transactionBloc.add(TransactionEventInsert(
                      transactionDTO: state.transactionDTO));
                }
              }),
              child: BlocConsumer<NotificationBloc, NotificationState>(
                  listener: (context, state) {
                if (state is NotificationReceivedSuccessState) {
                  _notificationBloc.add(NotificationEventUpdateStatus(
                      notificationId: state.notificationId));
                }
                if (state is NotificationUpdateSuccessState) {
                  String userId = UserInformationHelper.instance.getUserId();
                  _notificationBloc
                      .add(NotificationEventGetList(userId: userId));
                }
                if (state is NotificationListSuccessfulState) {
                  _notificationBloc.add(const NotificationInitialEvent());
                }
              }, builder: (context, state) {
                if (state is NotificationReceivedSuccessState) {
                  if (transactionByAddr
                      .containsKey(state.transactionDTO.address)) {
                    transactionByAddr[state.transactionDTO.address]!
                        .insert(0, state.transactionDTO);
                  } else {
                    transactionByAddr[state.transactionDTO.address] = [];
                    transactionByAddr[state.transactionDTO.address]!
                        .insert(0, state.transactionDTO);
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
                    if (state is TransactionSuccessfulListState) {
                      transactionByAddr.clear();
                      if (transactionByAddr.isEmpty && state.list.isNotEmpty) {
                        // _transactions.addAll(state.list);
                        for (TransactionDTO transactionDTO in state.list) {
                          if (transactionByAddr
                              .containsKey(transactionDTO.address)) {
                            transactionByAddr[transactionDTO.address]!.add(
                              transactionDTO,
                            );
                          } else {
                            transactionByAddr[transactionDTO.address] = [];
                            transactionByAddr[transactionDTO.address]!.add(
                              transactionDTO,
                            );
                          }
                        }
                      }
                    }
                  }),
                  builder: ((context, state) {
                    if (state is TransactionLoadingListState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: DefaultTheme.GREEN,
                        ),
                      );
                    }
                    if (state is TransactionSuccessfulListState) {
                      if (state.list.isEmpty) {
                        transactionByAddr.clear();
                      }
                    }
                    return Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              'Danh sách giao dịch',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: (transactionByAddr.isEmpty)
                              ? const Center(
                                  child: Text(
                                    'Không có giao dịch nào',
                                    style: TextStyle(
                                      color: DefaultTheme.GREY_TEXT,
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: transactionByAddr.isNotEmpty,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: transactionByAddr.length,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    itemBuilder: ((context, index) {
                                      String address = transactionByAddr.values
                                          .elementAt(index)
                                          .first
                                          .address
                                          .toString();
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SmsDetailScreen(
                                                address: address,
                                                transactions: transactionByAddr
                                                    .values
                                                    .elementAt(index),
                                              ),
                                            ),
                                          );
                                        },
                                        child: SMSListItem(
                                            transactionDTO: transactionByAddr
                                                .values
                                                .elementAt(index)
                                                .first),
                                      );
                                    }),
                                  ),
                                ),
                        ),
                      ],
                    );
                  }),
                );
              }),
            )
          : const SizedBox(),
    );
  }
}
