class DateTimeFormatted {
  final String time;
  final String date;

  DateTimeFormatted({required this.time, required this.date});
}

DateTimeFormatted formatDateTime(DateTime dateTime) {
  // Format time
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String time = '${_get12HourFormat(hour)}:$minute${_getAmPm(dateTime)}';

  // Format date
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0');
  String day = dateTime.day.toString().padLeft(2, '0');
  String date = '$year-$month-$day';

  return DateTimeFormatted(time: time, date: date);
}

String _get12HourFormat(String hour) {
  int hourInt = int.parse(hour);
  if (hourInt == 0) {
    return '12';
  } else if (hourInt > 12) {
    return (hourInt - 12).toString();
  } else {
    return hourInt.toString();
  }
}

String _getAmPm(DateTime dateTime) {
  return dateTime.hour >= 12 ? 'pm' : 'am';
}
