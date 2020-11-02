import 'package:flutter/material.dart';

Widget renderBoxPositions(positions) {
  // Widget listOfWidgets(List<String> item) {
  List<Widget> list = List<Widget>();
  if (positions.length > 0)
    for (var i = 0; i < positions.length; i++) {
      list.add(
        Container(
          margin: EdgeInsets.only(right: 12),
          width: 30,
          height: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${i + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: positions[i].color,
            // color: Colors.red,
            border: Border.all(width: 2.0, color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }
  return Row(
      // spacing: 5.0, // gap between adjacent chips
      // runSpacing: 2.0, // gap between lines
      children: list);
}
