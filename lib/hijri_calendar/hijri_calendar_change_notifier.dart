import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hijri/hijri_calendar.dart' as hijriCalendar;
import 'package:hijri_calendar/model/hijri_holiday.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const WEEK_VALUE = 7;

final hijriCalendarChangeNotifierProvider = ChangeNotifierProvider.autoDispose
    .family<HijriCalendarChangeNotifier, int>((ref, offset) {
  return HijriCalendarChangeNotifier(offset);
});

class HijriCalendarChangeNotifier extends ChangeNotifier {
  DualDate selectedDualDate;
  final List<DualDate> monthDates = [];
  final int offset;
  List<Result> islamicHolidays = [];

  HijriCalendarChangeNotifier(this.offset) {
    loadSortedHolidays();
    getDatesForThisMonth();
  }

  void getDatesForThisMonth() {
    final islamicDateToday = hijriCalendar.HijriCalendar.now();
    islamicDateToday.hDay = 1;
    print(islamicDateToday.wekDay());
    print(islamicDateToday.hDay);

    List<DualDate> dualDates = [];
    final weekday = getOffsetWeekday(islamicDateToday.wekDay());

    final emptyDates = getEmptyDates(weekday);
    if (emptyDates.isNotEmpty) {
      dualDates.addAll(emptyDates);
    }

    for (var i = 1; i < 31; i++) {
      var indexedDay = hijriCalendar.HijriCalendar();
      indexedDay.hYear = islamicDateToday.hYear;
      indexedDay.hMonth = islamicDateToday.hMonth;
      indexedDay.hDay = i;

      if (indexedDay.isValid()) {
        DateTime gregDate = indexedDay.hijriToGregorian(
            indexedDay.hYear, indexedDay.hMonth, indexedDay.hDay);
        DateTime correctedGregDate;
        if (offset > 0) {
          correctedGregDate = gregDate.add(Duration(days: offset));
        } else if (offset < 0) {
          correctedGregDate = gregDate.subtract(Duration(days: offset.abs()));
        } else {
          correctedGregDate = gregDate;
        }
        dualDates
            .add(DualDate(islamicDate: indexedDay, date: correctedGregDate));
      }
    }

    final today = DateTime.now();

    for (DualDate element in dualDates) {
      if (element != null) {
        if (element.date.day == today.day &&
            element.date.month == today.month &&
            element.date.year == today.year) {
          selectedDualDate = element;
          break;
        }
      }
    }

    if (selectedDualDate == null) {
      gotoNextMonth();
    } else {
      monthDates.clear();
      monthDates.addAll(dualDates);
      notifyListeners();
    }
  }

  List<DualDate> getEmptyDates(int wekDay) {
    List<DualDate> emptyDatesToReturn = [];
    if (wekDay < 7) {
      for (int i = 0; i < wekDay; i++) {
        emptyDatesToReturn.add(null);
      }
    }
    return emptyDatesToReturn;
  }

  int getOffsetWeekday(int wkday) {
    if (offset > 0) {
      if (wkday + offset <= 7) {
        return wkday + offset;
      } else if (offset + wkday == 8) {
        return 1;
      } else {
        return 2;
      }
    } else if (offset < 0) {
      if (wkday - offset.abs() >= 0) {
        print("returning ${wkday - offset}");
        return wkday - offset.abs();
      } else if (wkday - offset.abs() == -1) {
        return 6;
      } else {
        return 5;
      }
    } else {
      return wkday;
    }
  }

  void loadSortedHolidays() async {
    String jsonString = await rootBundle.loadString("assets/holidays.json");
    HijriHoliday h = hijriHolidayFromJson(jsonString);
    islamicHolidays.addAll(h.results);

    // Sorting holidays on the basis of hijriMonth
    islamicHolidays.sort((a, b) {
      int compare = a.hijriMonth.compareTo(b.hijriMonth);

      if (compare == 0) {
        // if hijriMonth is same, comparing with hijriDay to further sort the list
        return a.hijriDay.compareTo(b.hijriDay);
      } else {
        return compare;
      }
    });
    notifyListeners();
  }

  HijriHoliday hijriHolidayFromJson(String str) =>
      HijriHoliday.fromJson(json.decode(str));

  void selectDay(DualDate date) {
    selectedDualDate = date;
    notifyListeners();
  }

  void gotoNextMonth() {
    final islamicDateToday = selectedDualDate != null
        ? selectedDualDate.islamicDate
        : hijriCalendar.HijriCalendar.now();
    islamicDateToday.hDay = 1;
    final previousMonth = islamicDateToday.hMonth;
    if (previousMonth == 12) {
      islamicDateToday.hMonth = 1;
      islamicDateToday.hYear = islamicDateToday.hYear + 1;
    } else {
      islamicDateToday.hMonth = previousMonth + 1;
    }

    List<DualDate> dualDates = [];
    final weekday = getOffsetWeekday(islamicDateToday.wekDay());

    final emptyDates = getEmptyDates(weekday);
    if (emptyDates.isNotEmpty) {
      dualDates.addAll(emptyDates);
    }

    for (var i = 1; i < 31; i++) {
      var indexedDay = hijriCalendar.HijriCalendar();
      indexedDay.hYear = islamicDateToday.hYear;
      indexedDay.hMonth = islamicDateToday.hMonth;
      indexedDay.hDay = i;

      if (indexedDay.isValid()) {
        DateTime gregDate = indexedDay.hijriToGregorian(
            indexedDay.hYear, indexedDay.hMonth, indexedDay.hDay);
        DateTime correctedGregDate;
        if (offset > 0) {
          correctedGregDate = gregDate.add(Duration(days: offset));
        } else if (offset < 0) {
          correctedGregDate = gregDate.subtract(Duration(days: offset.abs()));
        } else {
          correctedGregDate = gregDate;
        }
        dualDates
            .add(DualDate(islamicDate: indexedDay, date: correctedGregDate));
      }
    }

    for (DualDate element in dualDates) {
      if (element != null) {
        selectedDualDate = element;
        break;
      }
    }

    final today = DateTime.now();

    for (DualDate element in dualDates) {
      if (element != null) {
        if (element.date.day == today.day &&
            element.date.month == today.month &&
            element.date.year == today.year) {
          selectedDualDate = element;
          break;
        }
      }
    }

    if (selectedDualDate == null) {
      gotoPreviousMonth();
    } else {
      monthDates.clear();
      monthDates.addAll(dualDates);
      notifyListeners();
    }
  }

  void gotoPreviousMonth() {
    final islamicDateToday = selectedDualDate != null
        ? selectedDualDate.islamicDate
        : hijriCalendar.HijriCalendar.now();
    islamicDateToday.hDay = 1;
    final previousMonth = islamicDateToday.hMonth;
    if (selectedDualDate != null) {
      if (previousMonth == 1) {
        islamicDateToday.hMonth = 12;
        islamicDateToday.hYear = islamicDateToday.hYear - 1;
      } else {
        islamicDateToday.hMonth = previousMonth - 1;
      }
    } else {
      if (previousMonth == 2) {
        islamicDateToday.hMonth = 12;
        islamicDateToday.hYear = islamicDateToday.hYear - 1;
      } else if (previousMonth == 1) {
        islamicDateToday.hMonth = 11;
        islamicDateToday.hYear = islamicDateToday.hYear - 1;
      } else {
        islamicDateToday.hMonth = previousMonth - 2;
      }
    }

    List<DualDate> dualDates = [];
    final weekday = getOffsetWeekday(islamicDateToday.wekDay());

    final emptyDates = getEmptyDates(weekday);
    if (emptyDates.isNotEmpty) {
      dualDates.addAll(emptyDates);
    }

    for (var i = 1; i < 31; i++) {
      var indexedDay = hijriCalendar.HijriCalendar();
      indexedDay.hYear = islamicDateToday.hYear;
      indexedDay.hMonth = islamicDateToday.hMonth;
      indexedDay.hDay = i;

      if (indexedDay.isValid()) {
        DateTime gregDate = indexedDay.hijriToGregorian(
            indexedDay.hYear, indexedDay.hMonth, indexedDay.hDay);
        DateTime correctedGregDate;
        if (offset > 0) {
          correctedGregDate = gregDate.add(Duration(days: offset));
        } else if (offset < 0) {
          correctedGregDate = gregDate.subtract(Duration(days: offset.abs()));
        } else {
          correctedGregDate = gregDate;
        }
        dualDates
            .add(DualDate(islamicDate: indexedDay, date: correctedGregDate));
      }
    }

    for (DualDate element in dualDates) {
      if (element != null) {
        selectedDualDate = element;
        break;
      }
    }

    final today = DateTime.now();

    for (DualDate element in dualDates) {
      if (element != null) {
        if (element.date.day == today.day &&
            element.date.month == today.month &&
            element.date.year == today.year) {
          selectedDualDate = element;
          break;
        }
      }
    }

    monthDates.clear();
    monthDates.addAll(dualDates);
    notifyListeners();
  }

  void onHolidaySelected(Result holiday) {
    final islamicDateToday = selectedDualDate.islamicDate;
    final previousDate = selectedDualDate.islamicDate;
    islamicDateToday.hDay = 1;
    islamicDateToday.hMonth = holiday.hijriMonth;
    islamicDateToday.hYear = previousDate.hYear;

    List<DualDate> dualDates = [];
    final weekday = getOffsetWeekday(islamicDateToday.wekDay());

    final emptyDates = getEmptyDates(weekday);
    if (emptyDates.isNotEmpty) {
      dualDates.addAll(emptyDates);
    }

    for (var i = 1; i < 31; i++) {
      var indexedDay = hijriCalendar.HijriCalendar();
      indexedDay.hYear = islamicDateToday.hYear;
      indexedDay.hMonth = islamicDateToday.hMonth;
      indexedDay.hDay = i;

      if (indexedDay.isValid()) {
        DateTime gregDate = indexedDay.hijriToGregorian(
            indexedDay.hYear, indexedDay.hMonth, indexedDay.hDay);
        DateTime correctedGregDate;
        if (offset > 0) {
          correctedGregDate = gregDate.add(Duration(days: offset));
        } else if (offset < 0) {
          correctedGregDate = gregDate.subtract(Duration(days: offset.abs()));
        } else {
          correctedGregDate = gregDate;
        }
        dualDates
            .add(DualDate(islamicDate: indexedDay, date: correctedGregDate));
      }
    }

    print("Hijri Day: ${holiday.hijriDay}");
    print("Hijri Month: ${holiday.hijriMonth}");

    for (DualDate element in dualDates) {
      if (element != null) {
        if (element.islamicDate.hDay == holiday.hijriDay &&
            element.islamicDate.hMonth == holiday.hijriMonth) {
          selectedDualDate = element;
          break;
        }
      }
    }

    monthDates.clear();
    monthDates.addAll(dualDates);
    notifyListeners();
  }
}

class DualDate {
  final DateTime date;
  final hijriCalendar.HijriCalendar islamicDate;

  DualDate({this.date, this.islamicDate});
}
