import 'package:flutter/material.dart';

String getDateText(
  DateTime date, {
  bool day = false,
  bool month = false,
  bool year = false,
}) {
  DateTime today = DateTime.now();
  String dateString = date.toString().split(" ")[0];
  List<String> dateStringSplit = dateString.split("-");
  String dayString = dateStringSplit[2];
  String monthString = dateStringSplit[1];
  String yearString = dateStringSplit[0];
  String res = "";
  if (day) res = dayString;
  if (month) res = "$res-$monthString";
  if (year) res = "$res-$yearString";
  if (res.isEmpty || date.year != today.year) {
    return "$dayString-$monthString-$yearString";
  }
  return res;
}

DateTime getDateTimeFromString(String dateText) {
  List<String> dateChunks = dateText.split('-');
  int year = int.parse(dateChunks[2]);
  int month = int.parse(dateChunks[1]);
  int day = int.parse(dateChunks[0]);

  return DateTime(year, month, day);
}

TimeOfDay getTimeOfDayFromString(String time) {
  List<String> timeChunks = time.split(':');
  int hour = int.parse(timeChunks[0]);
  int minute = int.parse(timeChunks[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
