import 'package:runtime/services/preference.dart';


void hourlyWork() async {
//load preferences
  var preferences = await Preference.loadPreference();
  var now = DateTime.now();
  var nextTime = nextHour(2);

  if (! (isInTimeRange(preferences)
      && isNotInBlockRange(preferences)
      && noRunYet(preferences))
      && noNotificationScheduled()
  ) {
    return;
  }

  var weatherInfo = await Weather.getInfo();
  if (! goodWeather(weatherInfo, nextTime)) {
    return;
  }


  // сalculate when to send notification(depend on user selectNotification choice in prefs)

  var notificationPref = preferences.selectedNotification;
  var notificationTime = nextTime.subtract(new Duration(minutes: notificationPref));


  // create a message
  getMessage(int id);

  // schedule the time to show notification
  Workmanager.registerOneOffTask("Notification",
      "NotificationTask",
      initialDelay: notificationTime.difference(now),
      inputData: {'message': "Run!"}
  );
  // save notification time into preferences

}

DateTime nextHour(int hours) {
  var now = DateTime.now(); //2021-02-07 16:49:33.340021
  var nextHour = now.add(new Duration(hours: hours));
  var roundedHour = DateTime(nextHour.year, nextHour.month, nextHour.day, nextHour.hour);
  return roundedHour;
}


//check if next hour is in the time range from prefs
bool isInTimeRange(preferences){
  var now = DateTime.now();
  var nextHour = DateTime(now.hour + 1); //or milliseconds?
  print(nextHour);

  var preferences = Preference();
  var rangeStart = preferences.getString('selectedRangeStart');//change tbe method type in the preference.dart
  var rangeEnd = preferences.getString('selectedRangeEnd');
  print(rangeStart);
  print(rangeEnd);

  if (nextHour.millisecondsSinceEpoch >= DateTime.parse(rangeStart).millisecondsSinceEpoch &&
      nextHour.millisecondsSinceEpoch <= DateTime.parse(rangeEnd).millisecondsSinceEpoch) {
    print('Next hour is in the range, let proceed with other checks');
    return true;
  } else {
    return false;
  }
}

String getMessage(int id) {
  if (id == 800) {
    return 'Perfect time for a run. Don\'t forget the sunscreen!';
  } else if (id > 800) {
    return 'Good time for a run';
  } else if (id == 781) {
    return 'You\'re better run now! Tornado is coming!';
  } else if (id > 700) {
    return 'Decent condition for a run, you\'re good to go';
  } else if (id > 600) {
    return 'Don\'t forget warm gloves and hat. Let it snow!';
  } else if (id > 500) {
    return 'it\'s raining, not a good time to go outside';
  } else if (id > 300) {
    return 'Drizzling outside, it\'s too wet for a run';
  } else if (id < 200) {
    return 'Thunderstorm is coming, it\'s better to stay inside';
  } else {
    return 'Bring a 🧥 just in case';
  }
}

//check the weather for the next hour

//check if the user has already run

//check when to send a notification from prefs

//schedule the notifications based on user prefs

//show notification in advance

