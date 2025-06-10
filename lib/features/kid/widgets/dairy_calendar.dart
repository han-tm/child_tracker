import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDairyCalendar extends StatefulWidget {
  final List<DairyModel> dairies;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;
  const CustomDairyCalendar({
    super.key,
    required this.dairies,
    required this.onDaySelected,
    this.selectedDay,
  });

  @override
  State<CustomDairyCalendar> createState() => _CustomDairyCalendarState();
}

class _CustomDairyCalendarState extends State<CustomDairyCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  initState() {
    super.initState();
    _selectedDay = widget.selectedDay ?? DateTime.now();
    _focusedDay = _selectedDay;
  }

  bool get isWeekFormat => _calendarFormat == CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: white, border: Border(bottom: BorderSide(color: greyscale200))),
      child: Column(
        children: [
          Stack(
            children: [
              TableCalendar(
                locale: 'ru',
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  headerMargin: EdgeInsets.zero,
                  headerPadding: EdgeInsets.symmetric(vertical: 12),
                  leftChevronPadding: EdgeInsets.zero,
                  leftChevronMargin: EdgeInsets.only(left: 22),
                  leftChevronIcon: Icon(CupertinoIcons.chevron_left, size: 20),
                  rightChevronIcon: Icon(CupertinoIcons.chevron_right, size: 20),
                  rightChevronPadding: EdgeInsets.zero,
                  rightChevronMargin: EdgeInsets.only(right: 22),
                ),
                headerVisible: !isWeekFormat,
                daysOfWeekHeight: isWeekFormat ? 26 : 22,
                rowHeight: isWeekFormat ? 42 : 54,
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    final String weekdayName = DateFormat.E(locale).format(date);
                    return weekdayName.substring(0, 1).toUpperCase() + weekdayName.substring(1);
                  },
                  weekdayStyle: TextStyle(
                    color: isWeekFormat ? greyscale700 : greyscale900,
                    fontSize: isWeekFormat ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  weekendStyle: TextStyle(
                    color: isWeekFormat ? greyscale700 : greyscale900,
                    fontSize: isWeekFormat ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  tablePadding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  cellMargin: EdgeInsets.symmetric(vertical: 6),
                  defaultTextStyle: TextStyle(
                    color: greyscale800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  selectedTextStyle: TextStyle(
                    color: primary900,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  outsideTextStyle: TextStyle(
                    color: greyscale400,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  holidayTextStyle: TextStyle(
                    color: greyscale800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  weekendTextStyle: TextStyle(
                    color: greyscale800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  todayTextStyle: TextStyle(
                    color: greyscale800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: Involve,
                  ),
                  todayDecoration: BoxDecoration(shape: BoxShape.circle),
                  defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                  isTodayHighlighted: false,
                  selectedDecoration: BoxDecoration(shape: BoxShape.circle),
                ),
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, day) {
                    return AppText(
                      text: getMonthYearInNominative(day),
                      fw: FontWeight.w700,
                      size: 20,
                      textAlign: TextAlign.center,
                    );
                  },
                  markerBuilder: (context, day, events) {
                    return events.isEmpty
                        ? null
                        : Container(
                            constraints: const BoxConstraints.expand(),
                            margin: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primary900,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 1),
                                child: AppText(
                                  text: '${day.day}',
                                  size: 16,
                                  height: 1,
                                  color: white,
                                  fw: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                  },
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      widget.onDaySelected(selectedDay);
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) => setState(() {
                  _calendarFormat = format;
                }),
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.now(),
                focusedDay: _focusedDay,
                eventLoader: (day) {
                  return widget.dairies.where((d) => isSameDay(d.time, day)).toList();
                },
              ),
              if (isWeekFormat)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) => weedDaySelector(index)),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _calendarFormat = !isWeekFormat ? CalendarFormat.week : CalendarFormat.month;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(
                    isWeekFormat ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget weedDaySelector(int index) {
    bool show = _focusedDay.weekday == index + 1;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 78,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: !show
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: primary900),
                    color: primary900.withOpacity(0.08),
                  ),
          ),
          // if (show)
          //   const Padding(
          //     padding: EdgeInsets.only(top: 2),
          //     child: Icon(Icons.lens, color: primary900, size: 8),
          //   ),
        ],
      ),
    );
  }
}
