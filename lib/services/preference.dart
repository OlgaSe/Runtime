import 'package:shared_preferences/shared_preferences.dart';

class Preference {

  int selectedDuration = 15;
  String selectedRangeStart = '6:00';
  String selectedRangeEnd = '6:30';
  String selectedBlockRangeStart = '7:00';
  String selectedBlockRangeEnd = '7:30';
  int selectedNotification = 15;


  Preference({this.selectedDuration, this.selectedRangeStart,
      this.selectedRangeEnd, this.selectedBlockRangeStart,
      this.selectedBlockRangeEnd, this.selectedNotification});

  savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedDuration', selectedDuration);
    prefs.setString('selectedRangeStart', selectedRangeStart);
    prefs.setString('selectedRangeEnd', selectedRangeEnd);
    prefs.setString('selectedBlockRangeStart', selectedBlockRangeStart);
    prefs.setString('selectedBlockRangeEnd', selectedBlockRangeEnd);
    prefs.setInt('selectedNotification', selectedNotification);
  }

  static loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Preference(
      selectedDuration: prefs.getInt('selectedDuration') ?? 15,
      selectedRangeStart: _getString(prefs, 'selectedRangeStart', '6:00'),
      selectedRangeEnd: _getString(prefs, 'selectedRangeEnd', '6:30'),
      selectedBlockRangeStart: _getString(prefs, 'selectedBlockRangeStart', '7:00'),
      selectedBlockRangeEnd: _getString(prefs, 'selectedBlockRangeEnd', '7:30'),
      selectedNotification: prefs.getInt('selectedNotification') ?? 15,
    );
  }

  static String _getString(SharedPreferences prefs, String key, String def) {
    var val = prefs.getString(key);
    return val != null && val != '' ? val : def;
  }

  @override
  String toString() {
    return 'Preference{selectedDuration: $selectedDuration, selectedRangeStart: $selectedRangeStart, selectedRangeEnd: $selectedRangeEnd, selectedBlockRangeStart: $selectedBlockRangeStart, selectedBlockRangeEnd: $selectedBlockRangeEnd, selectedNotification: $selectedNotification}';
  }
}
