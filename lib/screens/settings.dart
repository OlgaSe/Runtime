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
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String time in timeList) {
      var newItem = DropdownMenuItem(
        child: Text(time),
        value: time,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
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
                    value: _preferences.selectedDuration,
                    items: <int>[15, 30, 45, 60, 90]
                        .map((int value) {
                      return new DropdownMenuItem<int>(
                        value: value,
                        child: new Text("$value min"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _preferences.selectedDuration = value;
                      });
                    }),
              ],
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Time range'),
                    DropdownButton<String>(
                        value: _preferences.selectedRangeStart,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.selectedRangeStart = value;
                          });
                        }),
                    DropdownButton<String>(
                        value: _preferences.selectedRangeEnd,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.selectedRangeEnd = value;
                          });
                        }),
              ],
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Block time'),
                    DropdownButton<String>(
                        value: _preferences.selectedBlockRangeStart,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.selectedBlockRangeStart = value;
                          });
                        }),
                    DropdownButton<String>(
                        value: _preferences.selectedBlockRangeEnd,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.selectedBlockRangeEnd = value;
                          });
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('Notification'),
                    DropdownButton<int>(
                        value: _preferences.selectedNotification,
                        items: <int>[15, 30, 45, 60]
                            .map((int value) {
                          return new DropdownMenuItem<int>(
                            value: value,
                            child: Text("$value min"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _preferences.selectedNotification = value;
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
