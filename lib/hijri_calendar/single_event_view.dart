import 'package:flutter/material.dart';
import 'package:hijri_calendar/model/hijri_holiday.dart';
import 'package:hijri/hijri_calendar.dart' as hijriCalendar;
import 'package:intl/intl.dart';

class SingleEventView extends StatelessWidget {
  final Result holiday;
  final int currentYear;
  final int offset;
  final VoidCallback onPressed;
  final VoidCallback onInfo;

  const SingleEventView(this.holiday, this.currentYear, this.offset,
      {this.onPressed, this.onInfo});

  @override
  Widget build(BuildContext context) {
    var holidayDay = hijriCalendar.HijriCalendar();
    holidayDay.hYear = currentYear;
    holidayDay.hMonth = holiday.hijriMonth;
    holidayDay.hDay = holiday.hijriDay;

    var firstDay = hijriCalendar.HijriCalendar();
    DateTime date = firstDay.hijriToGregorian(
        holidayDay.hYear, holidayDay.hMonth, holidayDay.hDay);

    if (offset > 0) {
      date = date.add(Duration(days: offset.abs()));
    } else if (offset < 0) {
      date = date.subtract(Duration(days: offset.abs()));
    }

    return ListTile(
      title: Text(holiday.holidayName),
      subtitle: Text(holidayDay.toFormat("dd MMMM yyyy")),
      onTap: onPressed,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateFormat("MMM dd, yyyy").format(date)),
          InkWell(
            onTap: onInfo,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Icon(
                Icons.info_outline,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
