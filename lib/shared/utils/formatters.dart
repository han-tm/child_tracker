import 'package:intl/intl.dart';

String dateToStringDDMMYYYY(DateTime? date) =>
    date == null ? 'Неизвестно' : DateFormat('dd.MM.yyyy', 'ru').format(date);




const Map<int, String> _russianMonthsNominative = {
  1: 'Январь',
  2: 'Февраль',
  3: 'Март',
  4: 'Апрель',
  5: 'Май',
  6: 'Июнь',
  7: 'Июль',
  8: 'Август',
  9: 'Сентябрь',
  10: 'Октябрь',
  11: 'Ноябрь',
  12: 'Декабрь',
};

String getMonthYearInNominative(DateTime date) {
  final String month = _russianMonthsNominative[date.month]!;
  final String year = DateFormat('yyyy').format(date);
  return '$month $year';
}