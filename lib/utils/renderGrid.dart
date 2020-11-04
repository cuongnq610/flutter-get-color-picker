import 'package:flutter/material.dart';

Widget renderPositions(heightGrid) {
  // Widget listOfWidgets(List<String> item) {
  List<Widget> list = List<Widget>();
  for (var i = 0; i < 15; i++) {
    list.add(Container(
      height: heightGrid,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.transparent,
      ),
    ));
  }
  return GridView.count(crossAxisCount: 3, children: list);
}
