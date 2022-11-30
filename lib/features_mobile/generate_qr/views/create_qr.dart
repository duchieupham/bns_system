import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/additional_data.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/viet_qr_utils.dart';
import 'package:vierqr/commons/widgets/bank_card_widget.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/qr_generated_widget.dart';
import 'package:vierqr/commons/widgets/sub_header_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features_mobile/generate_qr/frames/create_qr_frame.dart';
import 'package:vierqr/features_mobile/generate_qr/views/qr_generated.dart';
import 'package:vierqr/features_mobile/generate_qr/widgets/input_content_widget.dart';
import 'package:vierqr/features_mobile/generate_qr/widgets/input_ta_widget.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/viet_qr_generate_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateQR extends StatefulWidget {
  final BankAccountDTO bankAccountDTO;

  const CreateQR({
    Key? key,
    required this.bankAccountDTO,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateQR();
}

class _CreateQR extends State<CreateQR> {
  static final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final TextEditingController amountController = TextEditingController();
  final TextEditingController msgController = TextEditingController();

  VietQRGenerateDTO _vietQRGenerateDTO = const VietQRGenerateDTO(
      cAIValue: '',
      transactionAmountValue: '',
      additionalDataFieldTemplateValue: '');

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: CreateQRFrame(
        width: width,
        height: height,
        mobileChildren: [
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
                        if ((Provider.of<CreateQRProvider>(context,
                                        listen: false)
                                    .transactionAmount ==
                                '0') ||
                            (Provider.of<CreateQRProvider>(context,
                                        listen: false)
                                    .transactionAmount ==
                                '')) {
                          DialogWidget.instance.openMsgDialog(
                              context, 'Vui lòng nhập số tiền cần thanh toán.');
                        } else {
                          _animatedToPage(1);
                        }
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
                        String additionalDataFieldTemplateValue = '';
                        if (msgController.text.isNotEmpty) {
                          additionalDataFieldTemplateValue = AdditionalData
                                  .PURPOSE_OF_TRANSACTION_ID +
                              VietQRUtils.instance
                                  .generateLengthOfValue(msgController.text) +
                              msgController.text;
                        }

                        VietQRGenerateDTO dto = VietQRGenerateDTO(
                          cAIValue: VietQRUtils.instance.generateCAIValue(
                              widget.bankAccountDTO.bankCode,
                              widget.bankAccountDTO.bankAccount),
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
                              bankAccountDTO: widget.bankAccountDTO,
                            ),
                          ),
                        );
                      },
                    );
            }),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20))
        ],
        widget1: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Số tiền cần thanh toán'),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Consumer<CreateQRProvider>(
                builder: (context, value, child) {
                  return Container(
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: (value.amountErr)
                              ? DefaultTheme.RED_TEXT
                              : DefaultTheme.GREY_TOP_TAB_BAR,
                          width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFieldWidget(
                      width: width,
                      isObscureText: false,
                      hintText: '(vd: 50000)',
                      controller: amountController,
                      inputType: TextInputType.number,
                      keyboardAction: TextInputAction.next,
                      onChange: (text) {
                        value.updateErr(!StringUtils.instance
                            .isNumeric(amountController.text));
                      },
                    ),
                  );
                },
              ),
              Consumer<CreateQRProvider>(builder: (context, value, child) {
                return Visibility(
                  visible: value.amountErr,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Số tiền không đúng định dạng, vui lòng nhập lại,',
                      style: TextStyle(
                        color: DefaultTheme.RED_TEXT,
                      ),
                    ),
                  ),
                );
              }),
              const Padding(padding: EdgeInsets.only(top: 20)),
              _buildTitle('Nội dung chuyển khoản'),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                width: width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: msgController,
                  autofocus: false,
                  maxLength: 99,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nội dung chứa tối đa 99 ký tự.',
                    hintStyle: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              ButtonWidget(
                width: width,
                text: 'Tạo mã QR',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  if (amountController.text.isNotEmpty &&
                      !Provider.of<CreateQRProvider>(context, listen: false)
                          .amountErr) {
                    String additionalDataFieldTemplateValue = '';
                    if (msgController.text.isNotEmpty) {
                      additionalDataFieldTemplateValue =
                          AdditionalData.PURPOSE_OF_TRANSACTION_ID +
                              VietQRUtils.instance
                                  .generateLengthOfValue(msgController.text) +
                              msgController.text;
                    }
                    _vietQRGenerateDTO = VietQRGenerateDTO(
                      cAIValue: VietQRUtils.instance.generateCAIValue(
                          widget.bankAccountDTO.bankCode,
                          widget.bankAccountDTO.bankAccount),
                      transactionAmountValue: amountController.text,
                      additionalDataFieldTemplateValue:
                          additionalDataFieldTemplateValue,
                    );
                    Provider.of<CreateQRProvider>(context, listen: false)
                        .updateQrGenerated(true);
                  }
                },
              ),
            ],
          ),
        ),
        widget2: BankCardWidget(bankAccountDTO: widget.bankAccountDTO),
        widget3: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Mã VietQR thanh toán'),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Expanded(
                child: Consumer<CreateQRProvider>(
                  builder: (context, value, child) {
                    return (value.qrGenerated)
                        ? Container(
                            width: width,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      DialogWidget.instance.openContentDialog(
                                        context,
                                        QRGeneratedWidget(
                                          isWeb: true,
                                          isExpanded: true,
                                          width: width,
                                          bankAccountDTO: widget.bankAccountDTO,
                                          vietQRGenerateDTO: _vietQRGenerateDTO,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(
                                        Icons.zoom_out_map_rounded,
                                        color: DefaultTheme.GREEN,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: QRGeneratedWidget(
                                    isWeb: true,
                                    width: width,
                                    bankAccountDTO: widget.bankAccountDTO,
                                    vietQRGenerateDTO: _vietQRGenerateDTO,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: DefaultTheme.GREY_TEXT, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Mã VietQR chưa được tạo.',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
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

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
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
