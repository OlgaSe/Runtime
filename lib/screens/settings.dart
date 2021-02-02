import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
          child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Duration of run'),
            DropdownButton<String>(
                items: <String>['15 min', '30 min', '60 min'].map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
              );
            }).toList(),
                onChanged: (value) {
              print(value);
            }),
          ],
        ),
      ])),
    );
  }
}
