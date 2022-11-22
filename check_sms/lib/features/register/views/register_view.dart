import 'package:check_sms/commons/widgets/sub_header_widget.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SubHeader(title: 'Đăng ký'),
        ],
      ),
    );
  }
}
