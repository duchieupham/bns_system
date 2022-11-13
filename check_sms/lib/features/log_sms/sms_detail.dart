import 'package:check_sms/commons/constants/configurations/theme.dart';
import 'package:check_sms/commons/utils/time_utils.dart';
import 'package:check_sms/commons/widgets/sub_header_widget.dart';
import 'package:check_sms/models/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class SmsDetailScreen extends StatefulWidget {
  final String address;
  final List<MessageDTO> messages;

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
                    margin:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            widget.messages[index].body.toString(),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        Text(
                          '\t${TimeUtils.instance.formatHour2(widget.messages[index].date.toString())}',
                          style: const TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                          ),
                        ),
                      ],
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
