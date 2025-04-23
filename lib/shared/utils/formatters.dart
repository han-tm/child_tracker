import 'package:intl/intl.dart';

String dateToStringDDMMYYYY(DateTime? date) =>
    date == null ? 'Неизвестно' : DateFormat('dd.MM.yyyy', 'ru').format(date);