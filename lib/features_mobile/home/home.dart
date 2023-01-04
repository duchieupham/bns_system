// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/table_type.dart';
import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features_mobile/generate_qr/views/create_qr.dart';
import 'package:vierqr/features_mobile/generate_qr/views/qr_information_view.dart';
import 'package:vierqr/features_mobile/home/frames/home_frame.dart';
import 'package:vierqr/features_mobile/home/widgets/bank_item_widget.dart';
import 'package:vierqr/features_mobile/log_sms/blocs/sms_bloc.dart';
import 'package:vierqr/features_mobile/log_sms/blocs/transaction_bloc.dart';
import 'package:vierqr/features_mobile/log_sms/events/sms_event.dart';
import 'package:vierqr/features_mobile/log_sms/events/transaction_event.dart';
import 'package:vierqr/features_mobile/log_sms/sms_list.dart';
import 'package:vierqr/features_mobile/log_sms/states/transaction_state.dart';
import 'package:vierqr/features_mobile/notification/blocs/notification_bloc.dart';
import 'package:vierqr/features_mobile/notification/events/notification_event.dart';
import 'package:vierqr/features_mobile/notification/repositories/notification_repository.dart';
import 'package:vierqr/features_mobile/notification/states/notification_state.dart';
import 'package:vierqr/features_mobile/notification/views/notification_view.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/features_mobile/personal/states/bank_manage_state.dart';
import 'package:vierqr/features_mobile/personal/views/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/notification_dto.dart';
import 'package:vierqr/models/transaction_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:vierqr/services/providers/account_balance_home_provider.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/home_tab_provider.dart';
import 'package:vierqr/services/providers/page_select_provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'dart:ui';

import 'package:vierqr/services/shared_references/user_information_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with WidgetsBindingObserver {
  //page controller
  static late PageController _pageController;
  // final CarouselController _carouselController = CarouselController();

  static int _notificationCount = 0;

  //list page
  final List<Widget> _homeScreens = [];
  static final List<Widget> _cardWidgets = [];
  static final List<BankAccountDTO> _bankAccounts = [];
  static final Map<String, List<TransactionDTO>> _transactionsByAddr = {};
  static final List<TransactionDTO> _transactions = [];
  static final List<NotificationDTO> _notifications = [];

  //focus node
  final FocusNode focusNode = FocusNode();

  //blocs
  late BankManageBloc _bankManageBloc;
  late NotificationBloc _notificationBloc;
  late TransactionBloc _transactionBloc;
  late SMSBloc _smsBloc;

  //providers
  final AccountBalanceHomeProvider accountBalanceHomeProvider =
      AccountBalanceHomeProvider('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bankManageBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _transactionBloc = BlocProvider.of(context);
    _smsBloc = BlocProvider.of(context);
    String userId = UserInformationHelper.instance.getUserId();
    if (PlatformUtils.instance.isWeb()) {
      _cardWidgets.clear();
      _bankAccounts.clear();
      _bankManageBloc.add(BankManageEventGetList(userId: userId));
      _notificationBloc.add(NotificationEventListen(
          userId: userId, notificationBloc: _notificationBloc));
      _transactionBloc.add(TransactionEventGetList(userId: userId));
      //
      Provider.of<HomeTabProvider>(context, listen: false).updateTabSelect(0);
      accountBalanceHomeProvider.updateAccountBalance('');
    } else {
      _notificationBloc.add(NotificationEventGetList(userId: userId));
      _homeScreens.addAll([
        const QRInformationView(
          key: PageStorageKey('QR_GENERATOR_PAGE'),
        ),
        if (!PlatformUtils.instance.isWeb())
          SMSList(
            key: const PageStorageKey('SMS_LIST_PAGE'),
          ),
        const UserSetting(
          key: PageStorageKey('USER_SETTING_PAGE'),
        ),
      ]);
    }
    _pageController = PageController(
      initialPage:
          Provider.of<PageSelectProvider>(context, listen: false).indexSelected,
      keepPage: true,
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('didChangeAppLifecycleState - state: $state');
  //   if (state == AppLifecycleState.resumed) {
  //     String userId = UserInformationHelper.instance.getUserId();
  //     _smsBloc.add(SMSEventListen(
  //       smsBloc: _smsBloc,
  //       userId: userId,
  //     ));
  //   }
  // }

  @override
  void dispose() {
    _notificationBloc.close();
    _bankManageBloc.close();
    _transactionBloc.close();
    NotificationRepository.notificationController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (!PlatformUtils.instance.isMobileFlatform(context)) {
      focusNode.requestFocus();
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: HomeFrame(
        width: width,
        height: height,
        mobileWidget: Stack(
          children: [
            //body
            PageView(
              key: const PageStorageKey('PAGE_VIEW'),
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<PageSelectProvider>(context, listen: false)
                    .updateIndex(index);
              },
              children: _homeScreens,
            ),
            //header
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 65,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 25,
                    sigmaY: 25,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<PageSelectProvider>(
                            builder: (context, page, child) {
                          return _getTitlePaqe(context, page.indexSelected);
                        }),
                        const Spacer(),
                        BlocConsumer<NotificationBloc, NotificationState>(
                            listener: (context, state) {
                          if (state is NotificationListSuccessfulState) {
                            _notifications.clear();
                            if (_notifications.isEmpty &&
                                state.list.isNotEmpty) {
                              _notifications.addAll(state.list);
                              _notificationCount = 0;
                              for (NotificationDTO dto in _notifications) {
                                if (!dto.isRead) {
                                  _notificationCount += 1;
                                }
                              }
                            }
                          }
                        }, builder: (context, state) {
                          if (state is NotificationListSuccessfulState) {
                            if (state.list.isEmpty) {
                              _notifications.clear();
                            }
                          }
                          if (state is NotificationsUpdateSuccessState) {
                            _notificationCount = 0;
                          }
                          return InkWell(
                            onTap: () {
                              List<String> notificationIds = [];
                              for (NotificationDTO dto in _notifications) {
                                if (!dto.isRead) {
                                  notificationIds.add(dto.id);
                                }
                              }
                              if (notificationIds.isNotEmpty) {
                                _notificationBloc.add(
                                    NotificationEventUpdateAllStatus(
                                        notificationIds: notificationIds));
                              }
                              if (_notifications.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(
                                      list: _notifications,
                                      notificationCount: _notificationCount,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 60,
                              width: 40,
                              child: Stack(
                                children: [
                                  Center(
                                      child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: const Icon(
                                      Icons.notifications_rounded,
                                      color: DefaultTheme.GREY_TEXT,
                                      size: 20,
                                    ),
                                  )),
                                  (_notificationCount != 0)
                                      ? Positioned(
                                          bottom: 5,
                                          right: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: DefaultTheme.RED_CALENDAR,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              _notificationCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: DefaultTheme.WHITE,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        widget1: BlocConsumer<BankManageBloc, BankManageState>(
            listener: (context, state) {
          if (state is BankManageListSuccessState) {
            Provider.of<BankAccountProvider>(context, listen: false)
                .updateIndex(0);
            if (_bankAccounts.isEmpty) {
              _bankAccounts.addAll(state.list);
              _bankAccounts.addAll(state.listOther);
              for (BankAccountDTO bankAccountDTO in _bankAccounts) {
                VietQRGenerateDTO dto = VietQRGenerateDTO(
                  cAIValue: VietQRUtils.instance.generateCAIValue(
                      bankAccountDTO.bankCode, bankAccountDTO.bankAccount),
                  transactionAmountValue: '',
                  additionalDataFieldTemplateValue: '',
                );
                //global key
                GlobalKey key = GlobalKey();
                final VietQRWidget qrWidget = VietQRWidget(
                  width: 400,
                  qrSize: 300,
                  bankAccountDTO: bankAccountDTO,
                  vietQRGenerateDTO: dto,
                  globalKey: key,
                  content: '',
                  isCopy: true,
                );
                _cardWidgets.add(qrWidget);
              }
            }
          }
          if (state is BankManageRemoveSuccessState ||
              state is BankManageAddSuccessState) {
            _bankAccounts.clear();
            _cardWidgets.clear();
            _bankManageBloc.add(BankManageEventGetList(
                userId: UserInformationHelper.instance.getUserId()));
          }
        }, builder: (context, state) {
          return Consumer<HomeTabProvider>(
            builder: (context, provider, child) {
              return (_bankAccounts.isNotEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: (provider.isExpanded)
                              ? const EdgeInsets.only(top: 20)
                              : const EdgeInsets.only(top: 15),
                        ),
                        (provider.isExpanded)
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                child: _buildTitle(
                                  'Tài khoản của bạn',
                                  DefaultTheme.RED_TEXT,
                                ),
                              )
                            : const SizedBox(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _bankAccounts.length,
                            shrinkWrap: true,
                            scrollDirection:
                                (PlatformUtils.instance.resizeWhen(width, 800))
                                    ? Axis.vertical
                                    : Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  accountBalanceHomeProvider
                                      .updateAccountBalance('');
                                  provider.updateTabSelect(index);
                                },
                                child: BankItemWidget(
                                  width: (PlatformUtils.instance
                                          .resizeWhen(width, 800))
                                      ? 300
                                      : 50,
                                  isSelected: provider.tabSelect == index,
                                  isExpanded: provider.isExpanded,
                                  bankAccountDTO: _bankAccounts[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          );
        }),
        widget2: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle('Danh sách giao dịch', Theme.of(context).hintColor),
                const Spacer(),
                BlocBuilder<BankManageBloc, BankManageState>(
                  builder: (context, state) {
                    return (_bankAccounts.isNotEmpty)
                        ? Consumer<HomeTabProvider>(
                            builder: (context, provider, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _bankAccounts[provider.tabSelect].bankName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_bankAccounts[provider.tabSelect].bankAccount} - ${_bankAccounts[provider.tabSelect].bankAccountName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                ValueListenableBuilder(
                                    valueListenable: accountBalanceHomeProvider,
                                    builder:
                                        (_, accountBalanceProvider, child) {
                                      return (accountBalanceHomeProvider.value
                                              .toString()
                                              .isNotEmpty)
                                          ? Text(
                                              'Số dư: ${accountBalanceProvider.toString()}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: DefaultTheme.GREEN,
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                              ],
                            );
                          })
                        : const SizedBox();
                  },
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: BlocConsumer<NotificationBloc, NotificationState>(
                listener: (context, state) {
                  if (state is NotificationReceivedSuccessState) {
                    DialogWidget.instance.openContentDialog(
                      context,
                      null,
                      _buildTransactionWidget(state.transactionDTO),
                    );
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
                },
                builder: (context, state) {
                  if (state is NotificationReceivedSuccessState) {
                    _transactions.insert(0, state.transactionDTO);
                  }
                  return BlocConsumer<TransactionBloc, TransactionState>(
                    listener: (context, state) {
                      if (state is TransactionSuccessfulListState) {
                        _transactions.clear();
                        if (_transactions.isEmpty && state.list.isNotEmpty) {
                          _transactions.addAll(state.list);
                          for (TransactionDTO transactionDTO in _transactions) {
                            if (_transactionsByAddr
                                .containsKey(transactionDTO.address)) {
                              _transactionsByAddr[transactionDTO.address]!.add(
                                transactionDTO,
                              );
                            } else {
                              _transactionsByAddr[transactionDTO.address] = [];
                              _transactionsByAddr[transactionDTO.address]!.add(
                                transactionDTO,
                              );
                            }
                          }
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is TransactionSuccessfulListState) {
                        if (state.list.isEmpty) {
                          _transactions.clear();
                        }
                      }
                      return Consumer<HomeTabProvider>(
                        builder: (context, provider, child) {
                          List<TransactionDTO> transactionsByadd = [];
                          if (_bankAccounts.isNotEmpty) {
                            if (_transactionsByAddr.containsKey(
                                _bankAccounts[provider.tabSelect].bankCode)) {
                              for (TransactionDTO transactionDTO
                                  in _transactions) {
                                if (transactionDTO.address ==
                                    _bankAccounts[provider.tabSelect]
                                        .bankCode) {
                                  transactionsByadd.add(transactionDTO);
                                }
                              }
                              Future.delayed(Duration.zero, () {
                                accountBalanceHomeProvider.updateAccountBalance(
                                    transactionsByadd[0].accountBalance);
                              });
                            }
                          }

                          return (transactionsByadd.isNotEmpty)
                              ? SizedBox(
                                  width: width,
                                  height: height,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 1,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: 620,
                                          height: height,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 620,
                                                child: Row(
                                                  children: [
                                                    TableRowWidget(
                                                      context: context,
                                                      tableType: TableType.NO,
                                                      alignment:
                                                          Alignment.center,
                                                      isHeader: true,
                                                      value: 'No.',
                                                    ),
                                                    TableRowWidget(
                                                      context: context,
                                                      tableType:
                                                          TableType.TRANSACTION,
                                                      alignment:
                                                          Alignment.center,
                                                      isHeader: true,
                                                      value: 'Giao dịch (VND)',
                                                    ),
                                                    TableRowWidget(
                                                      context: context,
                                                      tableType: TableType.TIME,
                                                      alignment:
                                                          Alignment.center,
                                                      isHeader: true,
                                                      value: 'Thời gian',
                                                    ),
                                                    TableRowWidget(
                                                      context: context,
                                                      tableType:
                                                          TableType.STATUS,
                                                      alignment:
                                                          Alignment.center,
                                                      isHeader: true,
                                                      value: 'Trạng thái',
                                                    ),
                                                    TableRowWidget(
                                                      context: context,
                                                      tableType:
                                                          TableType.CONTENT,
                                                      alignment:
                                                          Alignment.center,
                                                      isHeader: true,
                                                      widthRow: 200,
                                                      value: 'Nội dung',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildListTransaction(
                                                    width, transactionsByadd),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : const Center(
                                  child: Text(
                                    'Không có giao dịch nào',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: DefaultTheme.GREY_TEXT,
                                    ),
                                  ),
                                );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        widget3: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child:
                  _buildTitle('QR theo tài khoản', Theme.of(context).hintColor),
            ),
            Expanded(
              child: BlocBuilder<BankManageBloc, BankManageState>(
                builder: (context, state) {
                  return Consumer<HomeTabProvider>(
                    builder: (context, provider, child) {
                      return (_cardWidgets.isNotEmpty &&
                              _cardWidgets.length > provider.tabSelect)
                          ? _cardWidgets[provider.tabSelect]
                          : const SizedBox();
                    },
                  );
                },
              ),
            ),
            ButtonIconWidget(
              width: 300,
              icon: Icons.add_rounded,
              autoFocus: true,
              focusNode: focusNode,
              title: 'Tạo QR theo giao dịch',
              function: () {
                if (_bankAccounts.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateQR(
                        bankAccountDTO: _bankAccounts[
                            Provider.of<HomeTabProvider>(context, listen: false)
                                .tabSelect],
                      ),
                    ),
                  );
                } else {
                  DialogWidget.instance.openMsgDialog(
                      context: context,
                      title: 'Không thể tạo mã QR thanh toán',
                      msg:
                          'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
                }
              },
              bgColor: DefaultTheme.GREEN,
              textColor: Theme.of(context).primaryColor,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            ButtonIconWidget(
              width: 300,
              icon: Icons.people_rounded,
              autoFocus: true,
              focusNode: focusNode,
              title: 'Quản lý thành viên',
              function: () {},
              bgColor: DefaultTheme.GREEN,
              textColor: Theme.of(context).primaryColor,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            SizedBox(
              width: 300,
              child: Row(
                children: [
                  ButtonIconWidget(
                    width: 145,
                    icon: Icons.download_rounded,
                    autoFocus: true,
                    focusNode: focusNode,
                    title: 'Lưu',
                    function: () {},
                    bgColor: Theme.of(context).canvasColor,
                    textColor: DefaultTheme.GREEN,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ButtonIconWidget(
                    width: 145,
                    icon: Icons.print_rounded,
                    autoFocus: true,
                    focusNode: focusNode,
                    title: 'In',
                    function: () {},
                    bgColor: Theme.of(context).canvasColor,
                    textColor: DefaultTheme.GREEN,
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
      // HomeFrame2(
      //   width: width,
      //   height: height,
      //   mobileChildren: [
      //     PageView(
      //       key: const PageStorageKey('PAGE_VIEW'),
      //       allowImplicitScrolling: true,
      //       physics: const NeverScrollableScrollPhysics(),
      //       controller: _pageController,
      //       onPageChanged: (index) {
      //         Provider.of<PageSelectProvider>(context, listen: false)
      //             .updateIndex(index);
      //       },
      //       children: _homeScreens,
      //     ),
      //     SizedBox(
      //       width: MediaQuery.of(context).size.width,
      //       height: 65,
      //       child: ClipRRect(
      //         child: BackdropFilter(
      //           filter: ImageFilter.blur(
      //             sigmaX: 25,
      //             sigmaY: 25,
      //           ),
      //           child: Container(
      //             padding: const EdgeInsets.symmetric(horizontal: 20),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context)
      //                   .scaffoldBackgroundColor
      //                   .withOpacity(0.6),
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Consumer<PageSelectProvider>(
      //                     builder: (context, page, child) {
      //                   return _getTitlePaqe(context, page.indexSelected);
      //                 }),
      //                 const Spacer(),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      //   widget1: Container(
      //     width: width,
      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'Xin chào, ${UserInformationHelper.instance.getUserInformation().firstName}!',
      //           style: const TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.w500,
      //             fontStyle: FontStyle.italic,
      //           ),
      //         ),
      //         ValueListenableBuilder(
      //           builder: (_, clock, child) {
      //             return Center(
      //               child: Text(
      //                 clock.toString(),
      //               ),
      //             );
      //           },
      //           valueListenable: clockProvider,
      //         ),
      //         // Text(
      //         //   '${TimeUtils.instance.getCurrentDateInWeek()}, ${TimeUtils.instance.getCurentDate()}',
      //         //   maxLines: 1,
      //         //   overflow: TextOverflow.ellipsis,
      //         // ),
      //       ],
      //     ),
      //   ),
      //   widget2: Container(
      //     width: width,
      //     padding: const EdgeInsets.only(top: 10),
      //     child: Column(
      //       children: [
      //         TitleHomeWebWidget(
      //           width: width,
      //           iconAsset: 'assets/images/ic-qr.png',
      //           title: 'QR theo tài khoản',
      //           description: 'QR không chứa số tiền và nội dung',
      //         ),
      //         Expanded(
      //           child: Container(
      //             width: width,
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Expanded(
      //                   child: SizedBox(
      //                     width: width,
      //                     child: BlocConsumer<BankManageBloc, BankManageState>(
      //                       listener: ((context, state) {
      //                         if (state is BankManageListSuccessState) {
      //                           Provider.of<BankAccountProvider>(context,
      //                                   listen: false)
      //                               .updateIndex(0);
      //                           if (_bankAccounts.isEmpty) {
      //                             _bankAccounts.addAll(state.list);
      //                             for (BankAccountDTO bankAccountDTO
      //                                 in _bankAccounts) {
      //                               VietQRGenerateDTO dto = VietQRGenerateDTO(
      //                                 cAIValue: VietQRUtils.instance
      //                                     .generateCAIValue(
      //                                         bankAccountDTO.bankCode,
      //                                         bankAccountDTO.bankAccount),
      //                                 transactionAmountValue: '',
      //                                 additionalDataFieldTemplateValue: '',
      //                               );

      //                               //global key
      //                               GlobalKey key = GlobalKey();
      //                               final VietQRWidget qrWidget = VietQRWidget(
      //                                 width: 300,
      //                                 bankAccountDTO: bankAccountDTO,
      //                                 vietQRGenerateDTO: dto,
      //                                 globalKey: key,
      //                                 content: '',
      //                                 isCopy: true,
      //                               );
      //                               _cardWidgets.add(qrWidget);
      //                             }
      //                           }
      //                         }
      //                         if (state is BankManageRemoveSuccessState ||
      //                             state is BankManageAddSuccessState) {
      //                           _bankAccounts.clear();
      //                           _cardWidgets.clear();
      //                           _bankManageBloc.add(BankManageEventGetList(
      //                               userId: UserInformationHelper.instance
      //                                   .getUserId()));
      //                         }
      //                       }),
      //                       builder: ((context, state) {
      //                         return (_bankAccounts.isEmpty)
      //                             ? Container(
      //                                 width: width - 60,
      //                                 decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.circular(15),
      //                                 ),
      //                                 alignment: Alignment.center,
      //                                 child: Column(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.center,
      //                                   children: [
      //                                     const Text(
      //                                       'QR chưa được tạo.',
      //                                       textAlign: TextAlign.center,
      //                                       style: TextStyle(
      //                                         color: DefaultTheme.GREY_TEXT,
      //                                       ),
      //                                     ),
      //                                     const Padding(
      //                                         padding:
      //                                             EdgeInsets.only(top: 10)),
      //                                     ButtonIconWidget(
      //                                       width: 220,
      //                                       icon: Icons.add_rounded,
      //                                       title: 'Thêm tài khoản ngân hàng',
      //                                       bgColor: DefaultTheme.GREEN,
      //                                       textColor:
      //                                           Theme.of(context).primaryColor,
      //                                       function: () {
      //                                         Navigator.of(context).push(
      //                                           MaterialPageRoute(
      //                                             builder: (context) =>
      //                                                 const BankManageView(),
      //                                           ),
      //                                         );
      //                                       },
      //                                     ),
      //                                   ],
      //                                 ),
      //                               )
      //                             : Stack(
      //                                 fit: StackFit.expand,
      //                                 children: [
      //                                   CarouselSlider(
      //                                     carouselController:
      //                                         _carouselController,
      //                                     options: CarouselOptions(
      //                                       height: 400,
      //                                       enlargeCenterPage: true,
      //                                       enableInfiniteScroll: false,
      //                                       onPageChanged: ((index, reason) {
      //                                         Provider.of<BankAccountProvider>(
      //                                                 context,
      //                                                 listen: false)
      //                                             .updateIndex(index);
      //                                       }),
      //                                     ),
      //                                     items: _cardWidgets.map((i) {
      //                                       return i;
      //                                     }).toList(),
      //                                   ),
      //                                   Positioned(
      //                                     top: 0,
      //                                     right: 0,
      //                                     child: Tooltip(
      //                                       message: 'Phóng to mã QR',
      //                                       child: InkWell(
      //                                         onTap: () {
      //                                           VietQRGenerateDTO dto =
      //                                               VietQRGenerateDTO(
      //                                             cAIValue: VietQRUtils.instance.generateCAIValue(
      //                                                 _bankAccounts[Provider.of<
      //                                                                 BankAccountProvider>(
      //                                                             context,
      //                                                             listen: false)
      //                                                         .indexSelected]
      //                                                     .bankCode,
      //                                                 _bankAccounts[Provider.of<
      //                                                                 BankAccountProvider>(
      //                                                             context,
      //                                                             listen: false)
      //                                                         .indexSelected]
      //                                                     .bankAccount),
      //                                             transactionAmountValue: '',
      //                                             additionalDataFieldTemplateValue:
      //                                                 '',
      //                                           );
      //                                           //global key
      //                                           final GlobalKey key =
      //                                               GlobalKey();
      //                                           final VietQRWidget qrWidget =
      //                                               VietQRWidget(
      //                                             width: 300,
      //                                             bankAccountDTO: _bankAccounts[
      //                                                 Provider.of<BankAccountProvider>(
      //                                                         context,
      //                                                         listen: false)
      //                                                     .indexSelected],
      //                                             vietQRGenerateDTO: dto,
      //                                             globalKey: key,
      //                                             content: '',
      //                                           );
      //                                           DialogWidget.instance
      //                                               .openContentDialog(
      //                                             context,
      //                                             null,
      //                                             qrWidget,
      //                                           );
      //                                         },
      //                                         child: Container(
      //                                           width: 30,
      //                                           height: 30,
      //                                           decoration: BoxDecoration(
      //                                             color: Theme.of(context)
      //                                                 .canvasColor,
      //                                             borderRadius:
      //                                                 BorderRadius.circular(30),
      //                                           ),
      //                                           child: const Icon(
      //                                             Icons.zoom_out_map_rounded,
      //                                             color: DefaultTheme.GREY_TEXT,
      //                                             size: 15,
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   Positioned(
      //                                     top: 130,
      //                                     left: 0,
      //                                     child: ButtonNavigatePageWidget(
      //                                         width: 20,
      //                                         height: 50,
      //                                         function: () {
      //                                           _carouselController.animateToPage(
      //                                               Provider.of<BankAccountProvider>(
      //                                                           context,
      //                                                           listen: false)
      //                                                       .indexSelected -
      //                                                   1);
      //                                         },
      //                                         isPrevious: true),
      //                                   ),
      //                                   Positioned(
      //                                     top: 130,
      //                                     right: 0,
      //                                     child: ButtonNavigatePageWidget(
      //                                         width: 20,
      //                                         height: 50,
      //                                         function: () {
      //                                           _carouselController.animateToPage(
      //                                               Provider.of<BankAccountProvider>(
      //                                                           context,
      //                                                           listen: false)
      //                                                       .indexSelected +
      //                                                   1);
      //                                         },
      //                                         isPrevious: false),
      //                                   ),
      //                                 ],
      //                               );
      //                       }),
      //                     ),
      //                   ),
      //                 ),
      //                 const Padding(padding: EdgeInsets.only(top: 5)),
      //                 SizedBox(
      //                   width: 310,
      //                   child: Row(
      //                     children: [
      //                       ButtonIconWidget(
      //                         width: 150,
      //                         icon: Icons.download_rounded,
      //                         alignment: Alignment.center,
      //                         title: 'Lưu',
      //                         function: () {},
      //                         bgColor: Theme.of(context).cardColor,
      //                         textColor: DefaultTheme.GREEN,
      //                       ),
      //                       const Padding(padding: EdgeInsets.only(left: 10)),
      //                       ButtonIconWidget(
      //                         width: 150,
      //                         icon: Icons.print_rounded,
      //                         alignment: Alignment.center,
      //                         title: 'In',
      //                         function: () {},
      //                         bgColor: Theme.of(context).cardColor,
      //                         textColor: DefaultTheme.GREEN,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 const Padding(padding: EdgeInsets.only(top: 10)),
      //                 ButtonIconWidget(
      //                   width: 310,
      //                   icon: Icons.add_rounded,
      //                   autoFocus: true,
      //                   focusNode: focusNode,
      //                   title: 'Tạo QR theo giao dịch',
      //                   function: () {
      //                     if (_bankAccounts.isNotEmpty) {
      //                       Navigator.of(context).push(
      //                         MaterialPageRoute(
      //                           builder: (context) => CreateQR(
      //                             bankAccountDTO: _bankAccounts[
      //                                 Provider.of<BankAccountProvider>(context,
      //                                         listen: false)
      //                                     .indexSelected],
      //                           ),
      //                         ),
      //                       );
      //                     } else {
      //                       DialogWidget.instance.openMsgDialog(
      //                           context: context,
      //                           title: 'Không thể tạo mã QR thanh toán',
      //                           msg:
      //                               'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
      //                     }
      //                   },
      //                   bgColor: DefaultTheme.GREEN,
      //                   textColor: Theme.of(context).primaryColor,
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //   widget3: Container(
      //     width: width,
      //     padding: const EdgeInsets.only(top: 10),
      //     child: Column(
      //       children: [
      //         TitleHomeWebWidget(
      //           width: width,
      //           iconAsset: 'assets/images/ic-dashboard.png',
      //           title: 'Giao dịch',
      //           description: 'Danh sách các giao dịch gần đây',
      //         ),
      //         // Expanded(
      //         //   child: SizedBox(
      //         //     width: width,
      //         //     height: 570,
      //         //     child: (_transactions.isNotEmpty)
      //         //         ? ListView.builder(
      //         //             shrinkWrap: true,
      //         //             itemCount: _transactions.length,
      //         //             itemBuilder: ((context, index) {
      //         //               return SMSListItemWeb(
      //         //                   transactionDTO: _transactions[index]);
      //         //             }),
      //         //           )
      //         //         : const SizedBox(),
      //         //   ),
      //         // ),
      //         Expanded(
      //           child: BlocConsumer<NotificationBloc, NotificationState>(
      //             listener: (context, state) {
      //               if (state is NotificationReceivedSuccessState) {
      //                 DialogWidget.instance.openContentDialog(
      //                   context,
      //                   null,
      //                   _buildTransactionWidget(state.transactionDTO),
      //                 );
      //                 _notificationBloc.add(NotificationEventUpdateStatus(
      //                     notificationId: state.notificationId));
      //               }
      //               if (state is NotificationUpdateSuccessState) {
      //                 String userId =
      //                     UserInformationHelper.instance.getUserId();
      //                 _notificationBloc
      //                     .add(NotificationEventGetList(userId: userId));
      //               }
      //               if (state is NotificationListSuccessfulState) {
      //                 _notificationBloc.add(const NotificationInitialEvent());
      //               }
      //             },
      //             builder: (context, state) {
      //               if (state is NotificationReceivedSuccessState) {
      //                 _transactions.insert(0, state.transactionDTO);
      //               }
      //               return BlocConsumer<TransactionBloc, TransactionState>(
      //                 listener: (context, state) {
      //                   if (state is TransactionSuccessfulListState) {
      //                     _transactions.clear();
      //                     if (_transactions.isEmpty && state.list.isNotEmpty) {
      //                       _transactions.addAll(state.list);
      //                     }
      //                   }
      //                 },
      //                 builder: (context, state) {
      //                   if (state is TransactionSuccessfulListState) {
      //                     if (state.list.isEmpty) {
      //                       _transactions.clear();
      //                     }
      //                   }
      //                   return SizedBox(
      //                     width: width,
      //                     height: 570,
      //                     child: (_transactions.isNotEmpty)
      //                         ? ListView.builder(
      //                             shrinkWrap: true,
      //                             itemCount: _transactions.length,
      //                             itemBuilder: ((context, index) {
      //                               return SMSListItemWeb(
      //                                   transactionDTO: _transactions[index]);
      //                             }),
      //                           )
      //                         : const SizedBox(),
      //                   );
      //                 },
      //               );
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //   backgroundAsset: 'assets/images/bg-qr.png',
      // ),

      floatingActionButtonLocation: (PlatformUtils.instance.isWeb())
          ? null
          : FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (PlatformUtils.instance.isWeb())
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.6),
                      boxShadow: [
                        BoxShadow(
                          color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Stack(
                      children: [
                        Consumer<PageSelectProvider>(
                          builder: (context, page, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _buildShortcut(
                                  0,
                                  page.indexSelected,
                                  context,
                                ),
                                _buildShortcut(
                                  1,
                                  page.indexSelected,
                                  context,
                                ),
                                _buildShortcut(
                                  2,
                                  page.indexSelected,
                                  context,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  _buildListTransaction(
    double width,
    List<TransactionDTO> transactionsByadd,
  ) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.separated(
          itemCount: transactionsByadd.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          separatorBuilder: (context, index) {
            return Container(
              width: width,
              height: 0.5,
              decoration: const BoxDecoration(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
              ),
            );
          },
          itemBuilder: (context, index) {
            return Row(
              children: [
                TableRowWidget(
                  context: context,
                  tableType: TableType.NO,
                  alignment: Alignment.center,
                  value: (index + 1).toString(),
                ),
                TableRowWidget(
                  context: context,
                  tableType: TableType.TRANSACTION,
                  alignment: Alignment.center,
                  textColor: BankInformationUtil.instance
                          .isIncome((transactionsByadd[index].transaction))
                      ? DefaultTheme.GREEN
                      : DefaultTheme.RED_TEXT,
                  textSize: 18,
                  value: transactionsByadd[index].transaction.split(' VND')[0],
                ),
                TableRowWidget(
                  context: context,
                  tableType: TableType.TIME,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  value: TimeUtils.instance.formatDateFromTimeStamp2(
                    transactionsByadd[index].timeInserted,
                    false,
                  ),
                ),
                TableRowWidget(
                  context: context,
                  tableType: TableType.STATUS,
                  alignment: Alignment.center,
                  value: BankInformationUtil.instance
                      .formatTransactionStatus(transactionsByadd[index].status),
                ),
                TableRowWidget(
                  context: context,
                  tableType: TableType.CONTENT,
                  alignment: Alignment.centerLeft,
                  widthRow: 200,
                  value: transactionsByadd[index].content,
                ),
              ],
            );
          }),
    );
  }

  //build shorcuts in bottom bar
  _buildShortcut(int index, int indexSelected, BuildContext context) {
    bool isSelected = (index == indexSelected);
    return InkWell(
      onTap: () {
        _animatedToPage(index);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: (isSelected)
              ? Theme.of(context).toggleableActiveColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(
          _getAssetIcon(index, isSelected),
          width: 35,
          height: 35,
        ),
      ),
    );
  }

  //navigate to page
  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  //get image assets
  String _getAssetIcon(int index, bool isSelected) {
    const String prefix = 'assets/images/';
    String assetImage = (index == 0 && isSelected)
        ? 'ic-qr.png'
        : (index == 0 && !isSelected)
            ? 'ic-qr-unselect.png'
            : (index == 1 && isSelected)
                ? 'ic-dashboard.png'
                : (index == 1 && !isSelected)
                    ? 'ic-dashboard-unselect.png'
                    : (index == 2 && isSelected)
                        ? 'ic-user.png'
                        : 'ic-user-unselect.png';
    return '$prefix$assetImage';
  }

  //get title page
  Widget _getTitlePaqe(BuildContext context, int indexSelected) {
    Widget titleWidget = const SizedBox();
    if (indexSelected == 0) {
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: const [
            TextSpan(
              text: 'QR theo tài khoản\n',
            ),
            TextSpan(
              text: 'QR không chứa số tiền và nội dung.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
    if (indexSelected == 1) {
      /* title =
          '${TimeUtils.instance.getCurrentDateInWeek()}\n${TimeUtils.instance.getCurentDate()}';*/
      titleWidget = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.2,
          ),
          children: [
            const TextSpan(
              text: 'Trang chủ\n',
            ),
            TextSpan(
              text:
                  '${TimeUtils.instance.getCurrentDateInWeek(DateTime.now())}, ${TimeUtils.instance.getCurentDate(DateTime.now())}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: DefaultTheme.GREY_TEXT,
              ),
            ),
          ],
        ),
      );
    }
    if (indexSelected == 2) {
      titleWidget = const Text(
        'Cá nhân',
        style: TextStyle(
          fontFamily: 'NewYork',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }
    return titleWidget;
  }
}

Widget _buildTitle(String text, Color? color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Widget _buildTransactionWidget(
  TransactionDTO dto,
) {
  Color transactionColor =
      (BankInformationUtil.instance.isIncome(dto.transaction))
          ? DefaultTheme.GREEN
          : DefaultTheme.RED_TEXT;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Padding(padding: EdgeInsets.only(top: 30)),
      const Text(
        'Biến động số dư',
        maxLines: 1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Padding(padding: EdgeInsets.only(top: 5)),
      Text(
        dto.transaction,
        maxLines: 1,
        style: TextStyle(
          fontSize: 25,
          color: transactionColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Padding(padding: EdgeInsets.only(top: 20)),
      SizedBox(
        width: 300,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 80,
              child: Text(
                'Từ: ',
                style: TextStyle(
                  fontSize: 15,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
            ),
            Expanded(
              child: Text(
                dto.address,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      const Padding(padding: EdgeInsets.only(top: 10)),
      SizedBox(
        width: 300,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 80,
              child: Text(
                'Số dư: ',
                style: TextStyle(
                  fontSize: 15,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: Text(
                dto.accountBalance,
                style: TextStyle(
                  color: transactionColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      const Padding(padding: EdgeInsets.only(top: 10)),
      SizedBox(
        width: 300,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 80,
              child: Text(
                'Nội dung: ',
                style: TextStyle(
                  fontSize: 15,
                  color: DefaultTheme.GREY_TEXT,
                ),
              ),
            ),
            Expanded(
              child: Text(
                dto.content,
                //   dto.content,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget TableRowWidget({
  required BuildContext context,
  required TableType tableType,
  required String value,
  double? textSize,
  Color? textColor,
  bool? isHeader,
  double? widthRow,
  Alignment? alignment,
  TextAlign? textAlign,
}) {
  double width = 0;
  double height = 40;
  switch (tableType) {
    case TableType.NO:
      width = 50;
      break;
    case TableType.TRANSACTION:
      width = 150;
      break;
    case TableType.STATUS:
      width = 100;
      break;
    case TableType.TIME:
      width = 120;
      break;
    case TableType.CONTENT:
      width = widthRow!;
      break;
    default:
      width = 100;
      break;
  }
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.symmetric(vertical: 5),
    alignment: (alignment != null) ? alignment : Alignment.center,
    child: Text(
      value,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: (textSize != null) ? textSize : 12,
        color: (textColor != null) ? textColor : Theme.of(context).hintColor,
        fontWeight: (isHeader != null && isHeader)
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    ),
  );
}
