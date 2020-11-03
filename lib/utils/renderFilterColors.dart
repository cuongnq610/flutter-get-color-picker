import 'package:flutter/material.dart';

Widget renderFilterColors(colorsFilter, handleFilterColor, withItem) {
  // Widget listOfWidgets(List<String> item) {
  List<Widget> list = List<Widget>();
  if (colorsFilter.length > 0)
    for (var i = 0; i < colorsFilter.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          handleFilterColor(colorsFilter[i]);
        },
        child: Container(
          width: withItem,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: colorsFilter[i],
            border: Border.all(width: 1.0, color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ));
    }
  return Row(
      // spacing: 5.0, // gap between adjacent chips
      // runSpacing: 2.0, // gap between lines
      children: list);
}
