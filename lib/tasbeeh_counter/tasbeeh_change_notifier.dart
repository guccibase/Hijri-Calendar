import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

final tasbeehChangeNotifierProvider =
    ChangeNotifierProvider((ref) => TasbeehChangeNotifier());

class TasbeehChangeNotifier extends ChangeNotifier {
  SharedPreferences _sharedPreferences;

  bool shouldVibrate = true;

  int count = 0;
  int setCount = 0;
  int totalCount = 0;

  TasbeehChangeNotifier() {
    initSharedPreference();
  }

  void initSharedPreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setInitialValues();
  }

  void onIncrement() async {
    vibrate();
    if (count == setCount) {
      await _sharedPreferences.setInt("count", 1);
      count = _sharedPreferences.getInt("count") ?? 0;
      await _sharedPreferences.setInt("total_count", totalCount + 1);
      totalCount = _sharedPreferences.getInt("total_count") ?? 0;
    } else {
      await _sharedPreferences.setInt("count", count + 1);
      count = _sharedPreferences.getInt("count") ?? 0;
      await _sharedPreferences.setInt("total_count", totalCount + 1);
      totalCount = _sharedPreferences.getInt("total_count") ?? 0;
    }
    notifyListeners();
  }

  void setInitialValues() {
    count = _sharedPreferences.getInt("count") ?? 0;
    setCount = _sharedPreferences.getInt("set_count") ?? 33;
    totalCount = _sharedPreferences.getInt("total_count") ?? count;
    shouldVibrate = _sharedPreferences.getBool("vibrate") ?? true;
    notifyListeners();
  }

  void resetCounter() async {
    await _sharedPreferences.setInt("count", 0);
    await _sharedPreferences.setInt("total_count", 0);
    count = 0;
    totalCount = 0;
    notifyListeners();
  }

  void saveSetCount(int number) async {
    await _sharedPreferences.setInt("set_count", number);
    setCount = number;
    notifyListeners();
  }

  void vibrate() async {
    if (!shouldVibrate) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 150);
    }
  }

  void longVibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  void toggleVibration() async {
    await _sharedPreferences.setBool("vibration", !shouldVibrate);
    shouldVibrate = !shouldVibrate;
    notifyListeners();
  }
}
