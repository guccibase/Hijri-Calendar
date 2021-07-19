// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hijri_calendar/asma_ul_husna/asmaulhusna_change_notifier.dart';
// import 'package:hijri_calendar/asma_ul_husna/single_name_item.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// class AsmaUlHusnaScreen extends HookWidget {
//   @override
//   Widget build(BuildContext context) {
//     final namesController = useProvider(asmaUlHusnaChangeNotifierProvider);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text("Asma-ul-Husna"),
//       ),
//       backgroundColor: Color(0xFFF8F8F8),
//       body: ListView.builder(
//         itemBuilder: (context, index) {
//           final name = namesController.names[index];
//           return SingleNameItem(
//             name,
//             onPlay: () {
//               namesController.play(name.number);
//             },
//           );
//         },
//         itemCount: namesController.names.length,
//       ),
//     );
//   }
// }
