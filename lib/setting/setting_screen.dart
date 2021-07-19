import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hijri_calendar/hijri_calendar/hijri_calendar_screen.dart';
import 'package:hijri_calendar/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingScreen extends HookWidget {
  final list = [-2, -1, 0, 1, 2];

  @override
  Widget build(BuildContext context) {
    final int offset =
        useProvider(sharedPreferernceProvider).getInt("offset") ?? 0;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HijriCalendarScreen()),
            (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Color(0xFFE0DCDC),
        body: Container(
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  "Hijri Date Correction",
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                    "${offset < 0 ? offset * -1 : offset == 0 ? offset : -offset} Day"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Select Hijri Correction"),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      "${list[index] < 0 ? list[index] * -1 : list[index] == 0 ? list[index] : -list[index]} Day"),
                                  onTap: () async {
                                    await context
                                        .read(sharedPreferernceProvider)
                                        .setInt("offset", list[index]);
                                    Navigator.of(context).pop();
                                    context.refresh(sharedPreferernceProvider);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(height: 1);
                              },
                              itemCount: list.length,
                            ),
                          ),
                        );
                      });
                },
              ),
              Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
