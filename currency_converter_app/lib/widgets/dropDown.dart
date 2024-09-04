import 'package:flutter/material.dart';

Widget customDropDown(
  List<String> items,
  String value,
  ValueChanged<String?> onChange,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 18.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: DropdownButton<String>(
      value: value.isNotEmpty ? value : null,
      hint: Text("Select Currency"),
      onChanged: onChange,
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    ),
  );
}
