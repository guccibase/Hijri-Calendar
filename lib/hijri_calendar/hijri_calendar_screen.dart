import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hijri_calendar/hijri_calendar/hijri_calendar_change_notifier.dart';
import 'package:hijri_calendar/hijri_calendar/single_day_view.dart';
import 'package:hijri_calendar/hijri_calendar/single_event_view.dart';
import 'package:hijri_calendar/main.dart';
import 'package:hijri_calendar/model/hijri_holiday.dart';
import 'package:hijri_calendar/setting/setting_screen.dart';
import 'package:hijri_calendar/tasbeeh_counter/tasbeeh_counter_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const List<String> daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"];

class HijriCalendarScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final int offset =
        useProvider(sharedPreferernceProvider).getInt("offset") ?? 0;
    final hijriCalendarController =
        useProvider(hijriCalendarChangeNotifierProvider(offset));
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (_) {
              return {"Settings"}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (option) {
              if (option == "Asma-ul-Husna") {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (route) => AsmaUlHusnaScreen()));
              } else if (option == "Tasbeeh Counter") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (route) => TasbeehCounterScreen()));
              } else if (option == "Settings") {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (route) => SettingScreen()));
              }
            },
          ),
        ],
        title: ListTile(
          title: Text(
            hijriCalendarController.selectedDualDate != null
                ? hijriCalendarController.selectedDualDate.islamicDate
                    .toFormat("MMMM dd yyyy")
                : "",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            hijriCalendarController.selectedDualDate != null
                ? DateFormat("MMMM dd yyyy")
                    .format(hijriCalendarController.selectedDualDate.date)
                : "",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Color(0xFFE0DCDC),
      body: MediaQuery.of(context).size.width > 1100
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CalendarWidget(
                      offset: offset,
                      hijriCalendarController: hijriCalendarController),
                ),
                HolidaysWidget(
                    hijriCalendarController: hijriCalendarController,
                    offset: offset)
              ],
            )
          : Column(
              children: [
                CalendarWidget(
                    offset: offset,
                    hijriCalendarController: hijriCalendarController),
                HolidaysWidget(
                    hijriCalendarController: hijriCalendarController,
                    offset: offset)
              ],
            ),
    );
  }
}

class HolidaysWidget extends StatelessWidget {
  const HolidaysWidget({
    Key key,
    @required this.hijriCalendarController,
    @required this.offset,
  }) : super(key: key);

  final HijriCalendarChangeNotifier hijriCalendarController;
  final int offset;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final Result holiday =
                hijriCalendarController.islamicHolidays[index];
            return hijriCalendarController.selectedDualDate != null
                ? SingleEventView(
                    holiday,
                    hijriCalendarController.selectedDualDate.islamicDate.hYear,
                    offset,
                    onPressed: () {
                      context
                          .read(hijriCalendarChangeNotifierProvider(offset))
                          .onHolidaySelected(holiday);
                    },
                    onInfo: () async {
                      if (kIsWeb) {
                        await canLaunch(holiday.url)
                            ? await launch(
                                holiday.url,
                                headers: <String, String>{
                                  'my_header_key': holiday.holidayName
                                },
                              )
                            : throw 'Could not launch $holiday.url';
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route) =>
                                WebInfoView(holiday.holidayName, holiday.url),
                          ),
                        );
                      }
                    },
                  )
                : Container();
          },
          itemCount: hijriCalendarController.islamicHolidays.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 1, thickness: 2);
          },
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    Key key,
    @required this.offset,
    @required this.hijriCalendarController,
  }) : super(key: key);

  final int offset;
  final HijriCalendarChangeNotifier hijriCalendarController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context
                  .read(hijriCalendarChangeNotifierProvider(offset))
                  .gotoPreviousMonth();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 24),
                child: Icon(Icons.arrow_back_ios_outlined)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7),
                  itemBuilder: (context, index) {
                    final dayOfWeek = daysOfWeek[index];
                    return Container(
                      child: Center(
                          child: Text(
                        dayOfWeek,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              dayOfWeek == "S" ? Colors.black54 : Colors.black,
                        ),
                      )),
                    );
                  },
                  itemCount: daysOfWeek.length,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4),
                  itemBuilder: (context, index) {
                    final date = hijriCalendarController.monthDates[index];
                    return SingleDayView(
                      date,
                      hijriCalendarController.islamicHolidays,
                      hijriCalendarController.selectedDualDate,
                      onSelected: (date) {
                        context
                            .read(hijriCalendarChangeNotifierProvider(offset))
                            .selectDay(date);
                      },
                    );
                  },
                  itemCount: hijriCalendarController.monthDates.length,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              context
                  .read(hijriCalendarChangeNotifierProvider(offset))
                  .gotoNextMonth();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 24),
                child: Icon(Icons.arrow_forward_ios_outlined)),
          ),
        ],
      ),
    );
  }
}

class WebInfoView extends StatefulWidget {
  final String name;
  final String url;

  const WebInfoView(this.name, this.url);

  @override
  _WebInfoViewState createState() => _WebInfoViewState();
}

class _WebInfoViewState extends State<WebInfoView> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.green,
      ),
      body: WebView(
        initialUrl: widget.url,
        gestureNavigationEnabled: true,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller != null) {
            if (await _controller.canGoBack()) {
              _controller.goBack();
            } else {
              Navigator.of(context).pop();
            }
          }
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
