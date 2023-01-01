import 'package:vierqr/main.dart';

class EventBlocHelper {
  const EventBlocHelper._privateConsrtructor();

  static const EventBlocHelper _instance =
      EventBlocHelper._privateConsrtructor();
  static EventBlocHelper get instance => _instance;

  Future<void> initialEventBlocHelper() async {
    await sharedPrefs.setBool('EVENT_LISTEN_SMS', false);
    await sharedPrefs.setBool('EVENT_LISTEN_NOTIFICATION', false);
  }

  Future<void> updateListenSMS(bool value) async {
    await sharedPrefs.setBool('EVENT_LISTEN_SMS', value);
  }

  bool isListenedSMS() {
    return sharedPrefs.getBool('EVENT_LISTEN_SMS')!;
  }

  Future<void> updateListenNotification(bool value) async {
    await sharedPrefs.setBool('EVENT_LISTEN_NOTIFICATION', value);
  }

  bool isListenedNotification() {
    return sharedPrefs.getBool('EVENT_LISTEN_NOTIFICATION')!;
  }
}
