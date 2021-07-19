import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hijri_calendar/tasbeeh_counter/tasbeeh_change_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasbeehCounterScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tasbeehController = useProvider(tasbeehChangeNotifierProvider);
    final totalCountTextController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasbeeh Counter"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total: ${tasbeehController.totalCount}",
                  style: TextStyle(fontSize: 16),
                ),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tasbeehController.count.toString(),
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "/",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tasbeehController.setCount.toString(),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  totalCountTextController.text =
                      tasbeehController.setCount.toString();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text("Set Total Tasbeeh Count"),
                            content: TextField(
                              controller: totalCountTextController,
                              decoration: InputDecoration(filled: true),
                              keyboardType: TextInputType.number,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (totalCountTextController
                                            .text.isNotEmpty ||
                                        totalCountTextController.text != "0") {
                                      tasbeehController.saveSetCount(int.parse(
                                          totalCountTextController.text));
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text("Save")),
                            ]);
                      });
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Spacer(),
          InkWell(
              onTap: () {
                tasbeehController.onIncrement();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Image.asset(
                    "assets/touch_icon.png",
                    height: 200,
                    width: 200,
                  ),
                ),
              )),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Reset Tasbeeh Counter"),
                            content: Text(
                                "WARNING: The counter will be reset to 0."),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    tasbeehController.resetCounter();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK")),
                            ],
                          );
                        });
                  },
                  heroTag: "1",
                  backgroundColor: Colors.green,
                  child: Icon(Icons.refresh),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    tasbeehController.toggleVibration();
                  },
                  heroTag: "2",
                  backgroundColor: Colors.green,
                  child: Icon(tasbeehController.shouldVibrate
                      ? Icons.vibration
                      : Icons.volume_mute),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
