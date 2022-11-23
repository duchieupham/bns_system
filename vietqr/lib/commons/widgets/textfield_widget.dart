import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final double width;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<Object>? onChange;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;

  const TextFieldWidget({
    Key? key,
    required this.width,
    required this.hintText,
    required this.controller,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            fontSize: 16,
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
