import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/constants/vietqr/additional_data.dart';
import 'package:check_sms/commons/constants/vietqr/default_bank_information.dart';
import 'package:check_sms/commons/constants/vietqr/qr_guid.dart';
import 'package:check_sms/commons/constants/vietqr/transfer_service_code.dart';
import 'package:check_sms/commons/constants/vietqr/viet_qr_id.dart';
import 'package:check_sms/commons/utils/viet_qr_utils.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/sub_header_widget.dart';
import 'package:check_sms/features/generate_qr/views/qr_generated.dart';
import 'package:check_sms/features/generate_qr/widgets/input_content_widget.dart';
import 'package:check_sms/features/generate_qr/widgets/input_ta_widget.dart';
import 'package:check_sms/features/generate_qr/widgets/qr_select_bank.dart';
import 'package:check_sms/models/bank_account_dto.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:check_sms/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateQR extends StatefulWidget {
  const CreateQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateQR();
}

class _CreateQR extends State<CreateQR> {
  static final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final TextEditingController msgController = TextEditingController();

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const QRSelectBankWidget(
        key: PageStorageKey('QR_SELECT_BANK'),
      ),
      const InputTAWidget(
        key: PageStorageKey('INPUT_TA_PAGE'),
      ),
      InputContentWidget(
        key: const PageStorageKey('INPUT_CONTENT_PAGE'),
        msgController: msgController,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Consumer<CreateQRPageSelectProvider>(
            builder: (context, page, child) {
              return SubHeader(
                title: 'Tạo mã VietQR',
                function: () {
                  if (page.indexSelected == 0) {
                    Provider.of<CreateQRProvider>(context, listen: false)
                        .reset();
                    Provider.of<CreateQRPageSelectProvider>(context,
                            listen: false)
                        .reset();

                    Navigator.pop(context);
                  } else {
                    _animatedToPage(page.indexSelected - 1);
                  }
                },
              );
            },
          ),
          Expanded(
            child: PageView(
              key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<CreateQRPageSelectProvider>(context, listen: false)
                    .updateIndex(index);
              },
              children: _pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Consumer<CreateQRPageSelectProvider>(
              builder: (context, page, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(0, page.indexSelected),
                    const Padding(
                        padding: EdgeInsets.only(
                      left: 5,
                    )),
                    _buildDot(1, page.indexSelected),
                    const Padding(
                        padding: EdgeInsets.only(
                      left: 5,
                    )),
                    _buildDot(2, page.indexSelected),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<CreateQRPageSelectProvider>(
                builder: (context, page, child) {
              return (page.indexSelected == 0)
                  ? ButtonWidget(
                      width: width,
                      text: 'Tiếp theo',
                      textColor: DefaultTheme.GREEN,
                      bgColor: Theme.of(context).cardColor,
                      function: () {
                        _animatedToPage(1);
                      },
                    )
                  : (page.indexSelected == 1)
                      ? ButtonWidget(
                          width: width,
                          text: 'Tiếp theo',
                          textColor: DefaultTheme.GREEN,
                          bgColor: Theme.of(context).cardColor,
                          function: () {
                            _animatedToPage(2);
                          },
                        )
                      : ButtonWidget(
                          width: width,
                          text: 'Tạo mã QR',
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          function: () {
                            int ta = int.tryParse(Provider.of<CreateQRProvider>(
                                        context,
                                        listen: false)
                                    .transactionAmount) ??
                                0;
                            //
                            String cAIValue = QRGuid.GUID +
                                VietQRId.POINT_OF_INITIATION_METHOD_ID +
                                VietQRUtils.instance.generateLengthOfValue(
                                    DefaultBankInformation.DEFAULT_CAI) +
                                DefaultBankInformation.DEFAULT_CAI +
                                VietQRId.TRANSFER_SERVCICE_CODE +
                                VietQRUtils.instance.generateLengthOfValue(
                                    TransferServiceCode
                                        .QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT) +
                                TransferServiceCode
                                    .QUICK_TRANSFER_FROM_QR_TO_BANK_ACCOUNT;
                            //
                            String additionalDataFieldTemplateValue = '';
                            if (msgController.text.isNotEmpty) {
                              additionalDataFieldTemplateValue = AdditionalData
                                      .PURPOSE_OF_TRANSACTION_ID +
                                  VietQRUtils.instance.generateLengthOfValue(
                                      msgController.text) +
                                  msgController.text;
                            }
                            final BankAccountDTO bankAccountDTO =
                                Provider.of<CreateQRPageSelectProvider>(context,
                                        listen: false)
                                    .bankAccountDTO;
                            VietQRGenerateDTO dto = VietQRGenerateDTO(
                              cAIValue: VietQRUtils.instance.generateCAIValue(
                                  bankAccountDTO.bankCode,
                                  bankAccountDTO.bankAccount),
                              //'0010A00000072701240006970436011090000067890208QRIBFTTA',
                              transactionAmountValue: ta.toString(),
                              additionalDataFieldTemplateValue:
                                  additionalDataFieldTemplateValue,
                            );
                            Provider.of<CreateQRPageSelectProvider>(context,
                                    listen: false)
                                .reset();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => QRGenerated(
                                  vietQRGenerateDTO: dto,
                                  bankAccountDTO: bankAccountDTO,
                                ),
                              ),
                            );
                          },
                        );
            }),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20))
        ],
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

  Widget _buildDot(int index, int indexSelected) {
    return Container(
      width: 25,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (index == indexSelected)
            ? DefaultTheme.WHITE
            : DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.6),
      ),
    );
  }
}
