import 'package:flutter/material.dart';
import 'package:hijri_calendar/model/asmaulhusna.dart';

class SingleNameItem extends StatelessWidget {
  final Name name;
  final VoidCallback onPlay;

  const SingleNameItem(this.name, {this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: EdgeInsets.only(top: 16),
        width: double.infinity,
        child: Center(
            child: Column(
          children: [
            Text(
              name.number.toString(),
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              name.name,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              name.transliteration.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                name.en.meaning,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child:
                    IconButton(icon: Icon(Icons.play_arrow), onPressed: onPlay))
          ],
        )),
      ),
    );
  }
}
