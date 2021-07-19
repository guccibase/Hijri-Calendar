// import 'dart:convert';
//
// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:hijri_calendar/model/asmaulhusna.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// final asmaUlHusnaChangeNotifierProvider =
//     ChangeNotifierProvider<AsmaUlHusnaChangeNotifier>(
//         (ref) => AsmaUlHusnaChangeNotifier());
//
// class AsmaUlHusnaChangeNotifier extends ChangeNotifier {
//   List<Name> names = [];
//
//   AsmaUlHusnaChangeNotifier() {
//     loadNames();
//   }
//
//   void loadNames() async {
//     String jsonString =
//         await rootBundle.loadString("assets/asma_ul_husna.json");
//     AsmaUlHusna asmaUlHusnaData = asmaUlHusnaFromJson(jsonString);
//     names.addAll(asmaUlHusnaData.names);
//     notifyListeners();
//   }
//
//   AsmaUlHusna asmaUlHusnaFromJson(String str) =>
//       AsmaUlHusna.fromJson(json.decode(str));
//
//   void play(int number) {
//     final audioCache = AudioCache(prefix: "assets/audio/");
//     audioCache.play("$number.mp3");
//   }
// }
