import 'package:check_sms/commons/widgets/sub_header.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class SmsDetailScreen extends StatefulWidget {
  final String address;
  final List<SmsMessage> messages;

  const SmsDetailScreen(
      {Key? key, required this.address, required this.messages})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmsDetailScreen();
}

class _SmsDetailScreen extends State<SmsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          SubHeader(title: widget.address),
          Visibility(
            visible: widget.messages.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: ((context, index) {
                  return Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
