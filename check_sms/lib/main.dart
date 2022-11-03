import 'package:check_sms/features/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BNSApp());
}

class BNSApp extends StatelessWidget {
  const BNSApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
