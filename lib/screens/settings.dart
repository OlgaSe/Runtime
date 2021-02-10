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
        title: Text('Settings'),
      ),
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Duration of run'),
                DropdownButton<int>(
                    value: _preferences.durationMin,
                    items: <int>[15, 30, 45, 60, 90]
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Time range'),
                    DropdownButton<int>(
                        value: _preferences.rangeStartMin,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.rangeStartMin = value;
                          });
                        }),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Block time'),
                    DropdownButton<int>(
                        value: _preferences.blockRangeStartMin,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.blockRangeStartMin = value;
                          });
                        }),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('Notification'),
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
                ElevatedButton(
                    onPressed: () {_preferences.savePreference(); Navigator.pop(context);},
                    child: Text('Save')),
      ])),
    );
  }
}
