import 'package:flutter/material.dart';

Widget renderPositions(positions, handleRemoveColor) {
  // Widget listOfWidgets(List<String> item) {
  List<Widget> list = List<Widget>();
  if (positions.length > 0)
    for (var i = 0; i < positions.length; i++) {
      list.add(
        Positioned(
            left: positions[i].globalX - 11,
            top: positions[i].globalY - 30,
            child: GestureDetector(
              onTap: () {
                handleRemoveColor(i);
              },
              child: Container(
                width: 22,
                height: 22,
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
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(width: 2.0, color: Colors.white),
                ),
              ),
            )),
      );
    }
  return Stack(
      // spacing: 5.0, // gap between adjacent chips
      // runSpacing: 2.0, // gap between lines
      children: list);
}
