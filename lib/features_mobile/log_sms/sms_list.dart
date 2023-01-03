import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
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
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/services/providers/shortcut_provider.dart';
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
    // _transactionBloc.add(TransactionEventGetList(userId: userId));
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initialServices(context);
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
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
                        if (transactionByAddr.isEmpty &&
                            state.list.isNotEmpty) {
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
                      return ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _buildShortcut(context),
                          _buildTitle('Danh sách giao dịch'),
                          (transactionByAddr.isEmpty)
                              ? SizedBox(
                                  width: width,
                                  height: 200,
                                  child: const Center(
                                    child: Text(
                                      'Không có giao dịch nào',
                                      style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT,
                                      ),
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: transactionByAddr.isNotEmpty,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                          const Padding(padding: EdgeInsets.only(bottom: 100)),
                        ],
                      );
                    }),
                  );
                }),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildShortcut(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ShortcutProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTitle('Phím tắt'),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      provider.updateExpanded(!provider.expanded);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: Icon(
                        (provider.expanded)
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 25,
                        color: DefaultTheme.GREY_TEXT,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            (provider.expanded)
                ? BoxLayout(
                    width: width,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Tạo QR\ngiao dịch',
                          icon: Icons.qr_code_rounded,
                          color: DefaultTheme.BLUE_TEXT,
                          function: () {},
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Tài khoản ngân hàng',
                          icon: Icons.credit_card,
                          color: DefaultTheme.ORANGE,
                          function: () {},
                        ),
                        _buildShorcutIcon(
                          widgetWidth: width,
                          title: 'Đăng nhập\nbằng QR',
                          icon: Icons.login_rounded,
                          color: DefaultTheme.GREEN,
                          function: () {},
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: (provider.expanded) ? 20 : 0,
              ),
              child: DividerWidget(width: width),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShorcutIcon(
      {required double widgetWidth,
      required String title,
      required IconData icon,
      required Color color,
      required VoidCallback function}) {
    return SizedBox(
      width: widgetWidth * 0.2,
      height: widgetWidth * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: widgetWidth * 0.08,
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
