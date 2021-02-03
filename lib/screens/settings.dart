import 'package:flutter/material.dart';
import 'package:runtime/services/preference.dart';
import 'package:runtime/services/time_data.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedDuration = '15 min';
  String selectedRangeStart = '0:00';
  String selectedRangeEnd = '3:00';
  String selectedBlockRangeStart = '1:00';
  String selectedBlockRangeEnd = '2:00';
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
                    items: <int>[15, 30, 45, 60]
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
                        value: selectedRangeStart,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            selectedRangeStart = value;
                          });
                        }),
                    DropdownButton<String>(
                        value: selectedRangeEnd,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            selectedRangeEnd = value;
                          });
                        }),
              ],
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Block time'),
                    DropdownButton<String>(
                        value: selectedBlockRangeStart,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            selectedBlockRangeStart = value;
                          });
                        }),
                    DropdownButton<String>(
                        value: selectedBlockRangeEnd,
                        items: getDropDownItems(),
                        onChanged: (value) {
                          setState(() {
                            selectedBlockRangeEnd = value;
                          });
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('Notification'),
                    DropdownButton<String>(
                        value: selectedNotification,
                        items: <String>['15 min', '30 min', '45 min', '60 min']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedNotification = value;
                          });
                        }),
                  ],
                ),
                ElevatedButton(onPressed: () => _preferences.savePreference(), child: Text('Save')),
      ])),
    );
  }
}
