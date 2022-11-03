import 'package:intl/intl.dart';

class TimeUtils {
  const TimeUtils._privateConsrtructor();

  static const TimeUtils _instance = TimeUtils._privateConsrtructor();
  static TimeUtils get instance => _instance;

  String formatHour(String date) {
    String formattedTime = '';
    DateFormat format = DateFormat('HH:mm');
    bool isValidDate = DateTime.tryParse(date.toString()) != null;
    if (date != '' && isValidDate) {
      formattedTime = format.format(DateTime.parse(date.toString()));
    }
    return formattedTime;
  }
}
