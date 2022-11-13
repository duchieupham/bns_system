import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class InputContentWidget extends StatelessWidget {
  final TextEditingController msgController;

  const InputContentWidget({
    Key? key,
    required this.msgController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width - 40,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).cardColor),
          child: TextField(
            controller: msgController,
            autofocus: false,
            maxLength: 99,
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
        const Text('Nhập nội dung thanh toán '),
        const Spacer(),
      ],
    );
  }
}
