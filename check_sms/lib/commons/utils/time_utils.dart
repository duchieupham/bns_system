import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

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

  //get date in week to display dashboard
  String getCurrentDateInWeek() {
    String result = '';
    DateTime _now = DateTime.now();
    DateFormat _format = DateFormat('yyyy-MM-dd-EEEE');
    String _formatted = _format.format(_now);
    result = formatDateOfWeek(_formatted.split('-')[3]);
    return result;
  }

  //get current date to display today_view
  String getCurentDate() {
    String result = '';
    DateTime _now = DateTime.now();
    String _day = DateFormat.d(Locale('en').countryCode).format(_now);
    String _month = formatMonthCalendar(
        DateFormat.M(Locale('en').countryCode).format(_now));
    result = _day + ' ' + _month;
    return result;
  }

  //format month in header of calendar
  String formatMonthCalendar(String month) {
    String result = '';
    String prefix = 'Tháng';
    bool? isNaN = (int.tryParse(month)!.isNaN);
    if (!isNaN) {
      int? montInt = int.tryParse(month);
      if (montInt == 1) {
        result = '$prefix Một';
      } else if (montInt == 2) {
        result = '$prefix Hai';
      } else if (montInt == 3) {
        result = '$prefix Ba';
      } else if (montInt == 4) {
        result = '$prefix Tư';
      } else if (montInt == 5) {
        result = '$prefix Năm';
      } else if (montInt == 6) {
        result = '$prefix Sáu';
      } else if (montInt == 7) {
        result = '$prefix Bảy';
      } else if (montInt == 8) {
        result = '$prefix Tám';
      } else if (montInt == 9) {
        result = '$prefix Chín';
      } else if (montInt == 10) {
        result = '$prefix Mười';
      } else if (montInt == 11) {
        result = '$prefix Mười Một';
      } else if (montInt == 12) {
        result = '$prefix Mười Hai';
      }
    }
    return result;
  }

//get date of week string
  String formatDateOfWeek(String value) {
    String result = '';
    if (value == 'Monday') {
      result = 'Thứ hai';
    } else if (value == 'Tuesday') {
      result = 'Thứ ba';
    } else if (value == 'Wednesday') {
      result = 'Thứ tư';
    } else if (value == 'Thursday') {
      result = 'Thứ năm';
    } else if (value == 'Friday') {
      result = 'Thứ sáu';
    } else if (value.contains('Saturday')) {
      result = 'Thứ bảy';
    } else if (value == 'Sunday') {
      result = 'Chủ nhật';
    }
    return result;
  }
}
