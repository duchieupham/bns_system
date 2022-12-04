import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/screen_resolution_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/setting_bank_sheet.dart';
import 'package:vierqr/features_mobile/personal/blocs/bank_manage_bloc.dart';
import 'package:vierqr/features_mobile/personal/events/bank_manage_event.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';

class BankCardWidget extends StatelessWidget {
  final double width;
  final BankAccountDTO bankAccountDTO;
  final bool? isRemove;
  final bool? margin;

  const BankCardWidget({
    Key? key,
    required this.width,
    required this.bankAccountDTO,
    this.isRemove,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double defaultRatio = (width < 380) ? width - 40 : 340;
    return UnconstrainedBox(
      child: Container(
        width: (width < 380) ? width - 45 : 340,
        height: (width < 380) ? (width - 45) / 1.7 : 200,
        margin: (margin != null && !margin!)
            ? null
            : const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DefaultTheme.BANK_CARD_COLOR_1,
              DefaultTheme.BANK_CARD_COLOR_2,
              DefaultTheme.BANK_CARD_COLOR_3,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isRemove != null && isRemove!)
                ? SizedBox(
                    width: defaultRatio - 20,
                    child: Row(
                      children: [
                        Text(
                          bankAccountDTO.bankCode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: defaultRatio / 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if (ScreenResolutionUtils.instance.isWeb()) {
                              DialogWidget.instance.openBoxWebConfirm(
                                context: context,
                                title: 'Xoá tài khoản ngân hàng',
                                confirmText: 'Xoá',
                                imageAsset: 'assets/images/ic-card.png',
                                description:
                                    'Bạn có muốn xoá ${bankAccountDTO.bankAccount} ra khỏi danh sách không?',
                                confirmFunction: () {
                                  final BankManageBloc bankManageBloc =
                                      BlocProvider.of(context);
                                  bankManageBloc.add(
                                    BankManageEventRemoveDTO(
                                      userId: UserInformationHelper.instance
                                          .getUserId(),
                                      bankCode: bankAccountDTO.bankAccount,
                                    ),
                                  );
                                },
                                confirmColor: DefaultTheme.RED_TEXT,
                              );
                            } else {
                              SettingBankSheet.instance.openSettingCard(
                                context,
                                UserInformationHelper.instance.getUserId(),
                                bankAccountDTO.bankAccount,
                              );
                            }
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              Icons.more_horiz_outlined,
                              color: Theme.of(context).hintColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    bankAccountDTO.bankCode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: defaultRatio / 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            Text(
              bankAccountDTO.bankName,
              maxLines: 1,
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: defaultRatio / 22,
                fontFamily: 'TimesNewRoman',
              ),
            ),
            const Spacer(),
            Text(
              bankAccountDTO.bankAccount,
              style: TextStyle(
                color: DefaultTheme.WHITE,
                fontSize: defaultRatio / 15,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'TimesNewRoman',
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              bankAccountDTO.bankAccountName.toUpperCase(),
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: defaultRatio / 20,
                fontFamily: 'TimesNewRoman',
              ),
            ),
            //const Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
    );
  }
}
