import 'package:intl/intl.dart';

String month(selectedDate) {
  String month;

  if (DateFormat.MMMM().format(selectedDate) == 'January') {
    month = 'Januari';
  } else if (DateFormat.MMMM().format(selectedDate) == 'February') {
    month = 'Februari';
  } else if (DateFormat.MMMM().format(selectedDate) == 'March') {
    month = 'Maret';
  } else if (DateFormat.MMMM().format(selectedDate) == 'April') {
    month = 'April';
  } else if (DateFormat.MMMM().format(selectedDate) == 'May') {
    month = 'Mei';
  } else if (DateFormat.MMMM().format(selectedDate) == 'June') {
    month = 'Juni';
  } else if (DateFormat.MMMM().format(selectedDate) == 'July') {
    month = 'Juli';
  } else if (DateFormat.MMMM().format(selectedDate) == 'August') {
    month = 'Agustus';
  } else if (DateFormat.MMMM().format(selectedDate) == 'September') {
    month = 'September';
  } else if (DateFormat.MMMM().format(selectedDate) == 'October') {
    month = 'Oktober';
  } else if (DateFormat.MMMM().format(selectedDate) == 'November') {
    month = 'November';
  } else {
    month = 'Desember';
  }

  return month;
}
