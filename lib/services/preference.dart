import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  int durationMin = 15;
  int rangeStartMin = 6 * 60;
  int rangeEndMin = 6 * 60 + 30;
  int blockRangeStartMin = 7 * 60;
  int blockRangeEndMin = 7 * 60 + 30;
  int notificationMin = 15;


  Preference({this.durationMin, this.rangeStartMin,
      this.rangeEndMin, this.blockRangeStartMin,
      this.blockRangeEndMin, this.notificationMin});

  savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('durationMin', durationMin);
    prefs.setInt('rangeStartMin', rangeStartMin);
    prefs.setInt('rangeEndMin', rangeEndMin);
    prefs.setInt('blockRangeStartMin', blockRangeStartMin);
    prefs.setInt('blockRangeEndMin', blockRangeEndMin);
    prefs.setInt('notificationMin', notificationMin);
  }

  static Future<Preference> loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Preference(
      durationMin: prefs.getInt('durationMin') ?? 15,
      rangeStartMin: prefs.getInt('rangeStartMin') ?? 6*60,
      rangeEndMin: prefs.getInt('rangeEndMin') ?? 6*60 + 30,
      blockRangeStartMin: prefs.getInt('blockRangeStartMin') ?? 7*60,
      blockRangeEndMin: prefs.getInt('blockRangeEndMin') ?? 7*60 + 30,
      notificationMin: prefs.getInt('notificationMin') ?? 15,
    );
  }


  @override
  String toString() {
    return 'Preference{selectedDuration: $durationMin, selectedRangeStart: $rangeStartMin, selectedRangeEnd: $rangeEndMin, selectedBlockRangeStart: $blockRangeStartMin, selectedBlockRangeEnd: $blockRangeEndMin, selectedNotification: $notificationMin}';
  }
}
