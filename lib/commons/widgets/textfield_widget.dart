import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';

class TextFieldWidget extends StatelessWidget {
  final double width;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<Object>? onChange;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;
  final double? fontSize;
  final TextfieldType? textfieldType;
  final String? title;
  final double? titleWidth;

  const TextFieldWidget({
    Key? key,
    required this.width,
    required this.hintText,
    required this.controller,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
    this.fontSize,
    this.textfieldType,
    this.title,
    this.titleWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (textfieldType != null && textfieldType == TextfieldType.LABEL)
        ? Container(
            width: width,
            height: 60,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: (titleWidth != null) ? titleWidth : 80,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: (fontSize != null) ? fontSize : 16,
                    ),
                  ),
                ),
                Flexible(
                  child: TextField(
                    obscureText: isObscureText,
                    controller: controller,
                    onChanged: onChange,
                    keyboardType: inputType,
                    textInputAction: keyboardAction,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: (fontSize != null) ? fontSize : 16,
                        color: (title != null)
                            ? DefaultTheme.GREY_TEXT
                            : Theme.of(context).hintColor,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ))
        : Container(
            width: width,
            height: 60,
            alignment: Alignment.center,
            child: TextField(
              obscureText: isObscureText,
              controller: controller,
              onChanged: onChange,
              keyboardType: inputType,
              textInputAction: keyboardAction,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: (fontSize != null) ? fontSize : 16,
                  color: Theme.of(context).hintColor,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          );
  }
}
