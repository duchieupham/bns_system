import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/constants/vietqr/default_bank_information.dart';
import 'package:check_sms/commons/utils/currency_utils.dart';
import 'package:check_sms/commons/widgets/button_widget.dart';
import 'package:check_sms/commons/widgets/header_button_widet.dart';
import 'package:check_sms/commons/widgets/qr_generated_widget.dart';
import 'package:check_sms/features/generate_qr/views/create_qr.dart';
import 'package:check_sms/models/viet_qr_generate_dto.dart';
import 'package:check_sms/services/providers/create_qr_page_select_provider.dart';
import 'package:check_sms/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QRGenerated extends StatelessWidget {
  final VietQRGenerateDTO dto;

  const QRGenerated({Key? key, required this.dto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(children: [
        HeaderButtonWidget(
          title: 'Mã QR của bạn',
          button: InkWell(
            onTap: () {
              Provider.of<CreateQRProvider>(context, listen: false).reset();
              Provider.of<CreateQRPageSelectProvider>(context, listen: false)
                  .updateIndex(0);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const CreateQR(),
                ),
              );
            },
            child: SizedBox(
              height: 60,
              child: Row(
                children: const [
                  Text(
                    'Tạo lại mã QR',
                    style: TextStyle(
                        fontSize: 16,
                        color: DefaultTheme.GREEN,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.refresh,
                    color: DefaultTheme.GREEN,
                  ),
                ],
              ),
            ),
          ),
        ),
        QRGeneratedWidget(width: width * 0.9, dto: dto),
        // Text('${dto.transactionAmountValue}'),
        // Text('${dto.additionalDataFieldTemplateValue}'),
        const Padding(padding: EdgeInsets.only(top: 30)),
        _buildInformationText(
            width * 0.9, 'Tên:', DefaultBankInformation.FULL_NAME),
        const Padding(padding: EdgeInsets.only(top: 10)),
        _buildInformationText(
            width * 0.9, 'Số TK:', DefaultBankInformation.DEFAULT_BANK_ACCOUNT),
        const Padding(padding: EdgeInsets.only(top: 10)),
        _buildInformationText(width * 0.9, 'Số tiền:',
            '${CurrencyUtils.instance.getCurrencyFormatted(dto.transactionAmountValue)} VND'),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: width * 0.9,
          child: const Text(
            'Nội dung:',
            style: TextStyle(
              fontSize: 16,
              color: DefaultTheme.GREY_TEXT,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.9,
          child: Text(
            (dto.additionalDataFieldTemplateValue.isEmpty)
                ? ''
                : dto.additionalDataFieldTemplateValue.substring(4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(
                width: width * 0.42,
                text: 'Trang chủ',
                textColor: DefaultTheme.GREEN,
                bgColor: Theme.of(context).buttonColor,
                function: () {
                  Provider.of<CreateQRProvider>(context, listen: false).reset();
                  Provider.of<CreateQRPageSelectProvider>(context,
                          listen: false)
                      .updateIndex(0);

                  Navigator.pop(context);
                },
              ),
              ButtonWidget(
                width: width * 0.42,
                text: 'Chia sẻ',
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {},
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
      ]),
    );
  }

  Widget _buildInformationText(double width, String title, String value) {
    return SizedBox(
      width: width,
      child: Row(children: [
        SizedBox(
          width: width * 0.3,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: DefaultTheme.GREY_TEXT,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.7,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ]),
    );
  }
}
