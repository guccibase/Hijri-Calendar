import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart' as hijriCalendar;
import 'package:hijri_calendar/hijri_calendar/hijri_calendar_change_notifier.dart';
import 'package:hijri_calendar/model/hijri_holiday.dart';

class SingleDayView extends StatelessWidget {
  final DualDate date;
  final List<Result> holidays;
  final DualDate currentDate;
  final Function(DualDate) onSelected;

  const SingleDayView(this.date, this.holidays, this.currentDate,
      {this.onSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> list =
        holidays.map((e) => "${e.hijriMonth},${e.hijriDay}").toList();
    return date == null
        ? Container()
        : InkWell(
            onTap: () {
              if (date != null) {
                onSelected(date);
              }
            },
            child: Container(
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: isToday()
                        ? BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 2),
                            shape: BoxShape.circle)
                        : (isSameDay()
                            ? BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 2),
                                shape: BoxShape.circle)
                            : null),
                    child: Text(
                      date.islamicDate.hDay.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      color: list.contains(
                              "${date.islamicDate.hMonth},${date.islamicDate.hDay}")
                          ? Colors.black
                          : Colors.white,
                      height: 4,
                      width: 4,
                    ),
                  )
                ],
              )),
            ),
          );
  }

  bool isToday() {
    var today = DateTime.now();
    var selectedDate = date.date;
    return today.day == selectedDate.day &&
        today.month == selectedDate.month &&
        today.year == selectedDate.year;
  }

  bool isSameDay() {
    var today = currentDate.date;
    var selectedDate = date.date;

    return today.day == selectedDate.day &&
        today.month == selectedDate.month &&
        today.year == selectedDate.year;
  }
}
