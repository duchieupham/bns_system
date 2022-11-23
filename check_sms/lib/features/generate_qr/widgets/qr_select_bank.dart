import 'package:check_sms/commons/widgets/bank_card_widget.dart';
import 'package:check_sms/features/personal/blocs/bank_manage_bloc.dart';
import 'package:check_sms/features/personal/events/bank_manage_event.dart';
import 'package:check_sms/features/personal/states/bank_manage_state.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:check_sms/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class QRSelectBankWidget extends StatelessWidget {
  const QRSelectBankWidget({Key? key}) : super(key: key);
  static final List<String> list = <String>['One', 'Two', 'Three', 'Four'];

  static late BankManageBloc _bankManageBloc;
  static final List<BankAccountDTO> _bankAccounts = [];

  void initialServices(BuildContext context) {
    _bankManageBloc = BlocProvider.of(context);
    _bankManageBloc.add(BankManageEventGetList(
        userId: UserInformationHelper.instance.getUserId()));
    if (_bankAccounts.isEmpty) {
      _bankAccounts.add(
          Provider.of<CreateQRPageSelectProvider>(context, listen: false)
              .bankAccountDTO);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    initialServices(context);
    return Column(
      children: [
        Container(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: BlocConsumer<BankManageBloc, BankManageState>(
            listener: ((context, state) {
              if (state is BankManageListSuccessState) {
                if (_bankAccounts.length == 1) {
                  _bankAccounts.addAll(state.list);
                }
              }
            }),
            builder: ((context, state) {
              return (_bankAccounts.isEmpty)
                  ? const SizedBox()
                  : Consumer<CreateQRPageSelectProvider>(
                      builder: ((context, value, child) {
                        return DropdownButton<BankAccountDTO>(
                          value: value.bankAccountDTO,
                          icon: Image.asset(
                            'assets/images/ic-dropdown.png',
                            width: 30,
                            height: 30,
                          ),
                          elevation: 0,
                          style: const TextStyle(fontSize: 15),
                          underline: const SizedBox(
                            height: 0,
                          ),
                          onChanged: (BankAccountDTO? selected) {
                            if (selected == null) {
                              value.updateBankAccountDTO(value.bankAccountDTO);
                            } else {
                              value.updateBankAccountDTO(selected);
                            }
                          },
                          items: _bankAccounts
                              .map<DropdownMenuItem<BankAccountDTO>>(
                                  (BankAccountDTO value) {
                            return DropdownMenuItem<BankAccountDTO>(
                              value: value,
                              child: SizedBox(
                                width: width - 110,
                                child: Text(
                                  (value.bankCode == '')
                                      ? value.bankName
                                      : '${value.bankCode} - ${value.bankName}',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    );
            }),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Consumer<CreateQRPageSelectProvider>(
          builder: ((context, value, child) {
            return (value.bankAccountDTO.bankAccount == '')
                ? const SizedBox()
                : SizedBox(
                    width: (width < 400) ? width : 400,
                    height: 200,
                    child: BankCardWidget(bankAccountDTO: value.bankAccountDTO),
                  );
          }),
        ),
      ],
    );
  }
}
