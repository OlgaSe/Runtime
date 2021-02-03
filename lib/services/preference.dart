import 'package:shared_preferences/shared_preferences.dart';

class Preference {

  int selectedDuration = 15;
  String selectedRangeStart = '';
  String selectedRangeEnd = '';
  String selectedBlockRangeStart = '';
  String selectedBlockRangeEnd = '';
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
      selectedRangeStart: prefs.getString('selectedRangeStart') ?? '',
      selectedRangeEnd: prefs.getString('selectedRangeEnd') ?? '',
      selectedBlockRangeStart: prefs.getString('selectedBlockRangeStart') ?? '',
      selectedBlockRangeEnd: prefs.getString('selectedBlockRangeEnd') ?? '',
      selectedNotification: prefs.getInt('selectedNotification') ?? 15,
    );
  }
}
