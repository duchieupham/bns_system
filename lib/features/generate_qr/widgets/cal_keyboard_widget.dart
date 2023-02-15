// ignore_for_file: use_key_in_widget_constructors
import 'package:vierqr/commons/widgets/cal_button_widget.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalKeyboardWidget extends StatelessWidget {
  final double width;
  final double height;

  const CalKeyboardWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double btnCalWidth = width * 0.25;
    return SizedBox(
        width: width,
        height: height,
        child: Consumer<CreateQRProvider>(
          builder: ((context, value, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 1.toString(),
                      function: () {
                        setValue(
                            1.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 2.toString(),
                      function: () {
                        setValue(
                            2.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 3.toString(),
                      function: () {
                        setValue(
                            3.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 4.toString(),
                      function: () {
                        setValue(
                            4.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 5.toString(),
                      function: () {
                        setValue(
                            5.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 6.toString(),
                      function: () {
                        setValue(
                            6.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 7.toString(),
                      function: () {
                        setValue(
                            7.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 8.toString(),
                      function: () {
                        setValue(
                            8.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 9.toString(),
                      function: () {
                        setValue(
                            9.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: '000',
                      function: () {
                        setValue('000', value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    CalButtonWidget(
                      size: btnCalWidth,
                      value: 0.toString(),
                      function: () {
                        setValue(
                            0.toString(), value.transactionAmount, context);
                      },
                      color: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: InkWell(
                        onTap: () {
                          clearText(value.transactionAmount, context);
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
            );
          }),
        ));
  }

  void setValue(String value, String currentValue, BuildContext context) {
    if (currentValue.isEmpty || currentValue == '0' || currentValue == '000') {
      if (value == '0' || value == '000') {
        value = '';
      }
    }
    if (value.length <= 9) {
      Provider.of<CreateQRProvider>(context, listen: false)
          .updateTransactionAmount(value);
    }
  }

  void clearText(String currentValue, BuildContext context) {
    if (currentValue.isNotEmpty) {
      Provider.of<CreateQRProvider>(context, listen: false)
          .removeTransactionAmount();
    }
  }
}