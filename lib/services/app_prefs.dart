import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  SharedPreferences _sharedPreferences;


  AppPreferences(this._sharedPreferences);

  static Future<AppPreferences> loadPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return AppPreferences(sharedPreferences);
  }

  DateTime getLastRunTime() {
    return _loadDatetimeValue("lastRunTime");
  }

  setLastRunTime(DateTime lastRuntTime) {
    _storeDatetimeValue(lastRuntTime, "lastRunTime");
  }

  DateTime getNotificationScheduledTime() {
    return _loadDatetimeValue("notificationScheduledTime");
  }

  setNotificationScheduledTime(DateTime notificationScheduledTime) {
    _storeDatetimeValue(notificationScheduledTime, "notificationScheduledTime");
  }

  _storeDatetimeValue(DateTime datetime, String key) {
    _sharedPreferences.setInt(key, datetime.millisecondsSinceEpoch);
  }

  DateTime _loadDatetimeValue(String key) {
    var storedValue = _sharedPreferences.getInt(key);
    return storedValue!=null ? DateTime.fromMillisecondsSinceEpoch(storedValue) : null;
  }
}
