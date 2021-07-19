import 'package:flutter/material.dart';
import 'package:hijri_calendar/hijri_calendar/hijri_calendar_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferernceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
      overrides: [sharedPreferernceProvider.overrideWithValue(prefs)],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hijri Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HijriCalendarScreen(),
    );
  }
}
