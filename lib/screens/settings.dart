import 'package:flutter/material.dart';
import 'package:runtime/services/preference.dart';
import 'package:runtime/services/time_data.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedDuration = '15 min';
  String selectedRangeStart = '6:00';
  String selectedRangeEnd = '6:30';
  String selectedBlockRangeStart = '7:00';
  String selectedBlockRangeEnd = '7:30';
  String selectedNotification = '15 min';

  Preference _preferences = Preference();

  @override
  void initState() {
    super.initState();

    loadPreferences();
  }

  Future loadPreferences() async {
    var loadedPreferences = await Preference.loadPreference();
    setState(() {
      _preferences = loadedPreferences;
    });
  }


  List<DropdownMenuItem> getDropDownItems() {
    List<DropdownMenuItem<int>> dropdownItems = [];

    for (int time in timeList) {
      var newItem = DropdownMenuItem(
        child: Text(formatMinutes(time)),
        value: time,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  String formatMinutes(int minutes) {
    var hours = minutes ~/ 60;
    var hoursString = hours > 9 ? hours.toString() : "0$hours" ;
    var mins = minutes % 60;
    var minsString = mins > 9 ? mins.toString() : "0$mins" ;

    return "$hoursString:$minsString";
  }

  @override
  Widget build(BuildContext context) {
    print("Building with preferences: $_preferences");

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
              // color: Colors.lightBlueAccent[100],
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Duration of run'),
                  SizedBox(width: 25.0),
                  DropdownButton<int>(
                      value: _preferences.durationMin,
                      items: <int>[15, 30, 45, 60]
                          .map((int value) {
                        return new DropdownMenuItem<int>(
                          value: value,
                          child: new Text("$value min"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _preferences.durationMin = value;
                        });
                      }),
                ],
              ),
            ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                  // color: Colors.lightBlueAccent[100],
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Time range'),
                      SizedBox(width: 55.0),
                      DropdownButton<int>(
                          value: _preferences.rangeStartMin,
                          items: getDropDownItems(),
                          onChanged: (value) {
                            setState(() {
                              _preferences.rangeStartMin = value;
                            });
                          }),
                      SizedBox(width: 55.0),
                      DropdownButton<int>(
                          value: _preferences.rangeEndMin,
                          items: getDropDownItems(),
                          onChanged: (value) {
                            setState(() {
                              _preferences.rangeEndMin = value;
                            });
                          }),
              ],
            ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                  // color: Colors.lightBlueAccent[100],
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Block time'),
                      SizedBox(width: 62.0),
                      DropdownButton<int>(
                          value: _preferences.blockRangeStartMin,
                          items: getDropDownItems(),
                          onChanged: (value) {
                            setState(() {
                              _preferences.blockRangeStartMin = value;
                            });
                          }),
                      SizedBox(width: 55.0),
                      DropdownButton<int>(
                          value: _preferences.blockRangeEndMin,
                          items: getDropDownItems(),
                          onChanged: (value) {
                            setState(() {
                              _preferences.blockRangeEndMin = value;
                            });
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                  // color: Colors.lightBlueAccent[100],
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Notification'),
                      SizedBox(width: 55.0),
                      DropdownButton<int>(
                          value: _preferences.notificationMin,
                          items: <int>[15, 30, 45, 60]
                              .map((int value) {
                            return new DropdownMenuItem<int>(
                              value: value,
                              child: Text("$value min"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _preferences.notificationMin = value;
                            });
                          }),
                    ],
                  ),
                ),
                Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                      onPressed: () {_preferences.savePreference(); Navigator.pop(context);
                      },
                      child: Text('Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
      ])),
    );
  }
}
