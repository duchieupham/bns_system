// ignore_for_file: use_key_in_widget_constructors
import 'package:check_sms/commons/widgets/cal_button_widget.dart';
import 'package:flutter/material.dart';

class CalKeyboardWidget extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController txtController;

  const CalKeyboardWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.txtController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double btnCalWidth = width * 0.25;
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CalButtonWidget(
                size: btnCalWidth,
                value: 1.toString(),
                function: () {
                  setValue(1.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 2.toString(),
                function: () {
                  setValue(2.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 3.toString(),
                function: () {
                  setValue(3.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CalButtonWidget(
                size: btnCalWidth,
                value: 4.toString(),
                function: () {
                  setValue(4.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 5.toString(),
                function: () {
                  setValue(5.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 6.toString(),
                function: () {
                  setValue(6.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CalButtonWidget(
                size: btnCalWidth,
                value: 7.toString(),
                function: () {
                  setValue(7.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 8.toString(),
                function: () {
                  setValue(8.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 9.toString(),
                function: () {
                  setValue(9.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CalButtonWidget(
                size: btnCalWidth,
                value: '00',
                function: () {
                  setValue('00');
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              CalButtonWidget(
                size: btnCalWidth,
                value: 0.toString(),
                function: () {
                  setValue(0.toString());
                },
                color: Colors.grey,
                textColor: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: InkWell(
                  onTap: () {
                    clearText();
                  },
                  child: Container(
                    width: width * 0.15,
                    height: width * 0.15,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(btnCalWidth),
                      color: Colors.red.withOpacity(0.4),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: (width * 0.2) / 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setValue(String value) {
    if (txtController.text.isEmpty && (value == '0' || value == '00')) {
    } else {
      txtController.text = txtController.text + value;
    }
  }

  void clearText() {
    if (txtController.text.isNotEmpty) {
      txtController.text =
          txtController.text.substring(0, txtController.text.length - 1);
    }
  }
}
