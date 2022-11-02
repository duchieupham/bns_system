import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart' as smslistener;
import 'package:permission_handler/permission_handler.dart';

late SmsQuery query;

void main() {
  query = SmsQuery();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SMS List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getSMS();
  }

  List<SmsMessage> messages = [];
  Map<String, List<SmsMessage>> messagesByAddr = {};

  Future<void> getSMS() async {
    await Permission.sms.request();
    //
    smslistener.FlutterSmsListener smsListener =
        smslistener.FlutterSmsListener();

    Stream<smslistener.SmsMessage> msgStream = smsListener.onSmsReceived!;
    msgStream.listen((msg) {
      print('----on msg: ${msg.address} - ${msg.body}');
      var snackBar = SnackBar(
        content: Text(
          msg.body.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    //

    messages = await query.getAllSms;
    if (messages.isNotEmpty) {
      for (int i = 0; i < messages.length; i++) {
        // print(
        //     '---message $i: id: ${messages[i].id} - address: ${messages[i].address} - msg: ${messages[i].body} - date sent: ${messages[i].dateSent}');
        if (messagesByAddr.containsKey(messages[i].address)) {
          messagesByAddr[messages[i].address]!.add(
            messages[i],
          );
        } else {
          messagesByAddr[messages[i].address ?? ''] = [];
          messagesByAddr[messages[i].address]!.add(
            messages[i],
          );
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Visibility(
              visible: messagesByAddr.isNotEmpty,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messagesByAddr.length,
                padding: const EdgeInsets.only(left: 10, right: 10),
                itemBuilder: ((context, index) {
                  return Container(
                    width: width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messagesByAddr.values
                                    .elementAt(index)
                                    .first
                                    .address
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                messagesByAddr.values
                                    .elementAt(index)
                                    .first
                                    .body
                                    .toString(),
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.2,
                          child: Text(
                            'undefined',
                          ),
                        )
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
