import 'package:intl/intl.dart';

String day(selectedDate) {
  String day = 'Hari ini';

  if (selectedDate.toString().split(' ')[0] ==
      DateTime.now().toString().split(' ')[0]) {
    day = 'Hari ini';
  } else if (DateFormat.EEEE().format(selectedDate) == 'Monday') {
    day = 'Senin';
  } else if (DateFormat.EEEE().format(selectedDate) == 'Tuesday') {
    day = 'Selasa';
  } else if (DateFormat.EEEE().format(selectedDate) == 'Wednesday') {
    day = 'Rabu';
  } else if (DateFormat.EEEE().format(selectedDate) == 'Thursday') {
    day = 'Kamis';
  } else if (DateFormat.EEEE().format(selectedDate) == 'Friday') {
    day = 'Jum\'at';
  } else if (DateFormat.EEEE().format(selectedDate) == 'Saturday') {
    day = 'Sabtu';
  } else {
    day = 'Minggu';
  }

  return day;
}
