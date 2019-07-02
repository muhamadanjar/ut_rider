import 'package:flutter/material.dart';
var classes = ["Business", "Economy"];
Widget tripDetailsWidget(bool value) {
  return Material(
      elevation: 4.0,
      child: value == true
          ? Container(
          width: 350.0,
          height: 300.0,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              flightDetailsWidget(Icons.date_range, 'Departure Date', 0,
                  subtitle: 'Mon, 14 Dec'),
              flightDetailsWidget(Icons.date_range, 'Arrival Date', 1,
                  subtitle: 'Sun, 15 Dec'),
              flightDetailsWidget(Icons.people, 'Passenger', 2,
                  subtitle: '1 Adult 0 Child 0 Infant'),
              flightDetailsWidget(Icons.people, 'Class', 3),
            ],
          ))
          : Container(
          width: 350.0,
          height: 300.0,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              flightDetailsWidget(Icons.date_range, 'Departure Date', 0,
                  subtitle: 'Mon, 14 Dec'),
              flightDetailsWidget(Icons.people, 'Passenger', 2,
                  subtitle: '1 Adult 0 Child 0 Infant'),
              flightDetailsWidget(Icons.people, 'Class', 3),
            ],
          )
      ));
}

Widget flightDetailsWidget(IconData icon, String title, int index, {String subtitle}) {
  return ListTile(
    title: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    subtitle: index == 3
        ? DropdownButton<String>(
      items: classes.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(
            dropDownStringItem,
          ),
        );
      }).toList(),
      onChanged: (String newItemSelected) {

      },
      style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16.0),
      value: classes[0],
    )
        : Text(subtitle,
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16.0)),
    leading: Icon(
      icon,
      color: Colors.grey,
    ),
  );
}