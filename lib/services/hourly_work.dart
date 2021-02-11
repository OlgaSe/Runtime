import 'package:runtime/services/preference.dart';
import 'package:workmanager/workmanager.dart';
import 'package:runtime/services/weather.dart';
import 'app_prefs.dart';
import 'package:intl/intl.dart';


hourlyWork({debug=false}) async {
//load preferences
  var userPreferences = await Preference.loadPreference();
  var appPreferences = await AppPreferences.loadPreferences();
  var nextTime = nextHour(2);

  print("Starting checks for $nextTime");

  if (!isInTimeRange(userPreferences, nextTime)) {
    print("Not in the user time range");
    return;
  }

  if (isInBlockRange(userPreferences, nextTime)) {
    print("Is in the blocked range");
    return;
  }

  if (hadRun(appPreferences, nextTime)) {
    print("User already had a run today");
    return;
  }

  print("Getting weather information");
  var weather = await Weather.getWeather();
  print("Got weather");
  var nextHourWeather = weather.getHourWeather(nextTime);
  if (nextHourWeather == null) {
    var hourInSeconds = nextTime.millisecondsSinceEpoch / 1000;
    print("Could not find weather for $hourInSeconds");
    print(weather.getRawWeatherData());
  }

  if (!Weather.isGoodWeather(nextHourWeather)) {
    print("Not good weather");
    return;
  }


  // сalculate when to send notification(depend on user selectNotification choice in prefs)
  var notificationPref = userPreferences.notificationMin;
  var notificationTime = nextTime.subtract(new Duration(minutes: notificationPref));
  if (debug == true) {
    notificationTime = DateTime.now().add(Duration(minutes: 1));
  }

  // create and schedule a message
  var message = getMessage(nextHourWeather['weather'][0]['id']);
  var formattedNextTime = DateFormat.Hm().format(nextTime);
  // var dateString = format.format(DateTime.now());

  var notificationMessage = "Next time slot is at: $formattedNextTime. $message";
  scheduleNotification(notificationMessage, notificationTime, appPreferences);
}

bool hadRun(AppPreferences appPreferences, DateTime nextTime) {
  var lastRunTime = appPreferences.getLastRunTime();
  return lastRunTime?.day == nextTime.day;
}

bool isInBlockRange(Preference userPreferences, DateTime nextTime) {
  var nextHourInMinutes = nextTime.hour*60 + nextTime.minute;

  if (nextHourInMinutes >= userPreferences.blockRangeStartMin
      && nextHourInMinutes <= userPreferences.blockRangeEndMin) {
    return true;
  } else {
    return false;
  }
}


DateTime nextHour(int hours) {
  var now = DateTime.now(); //2021-02-07 16:49:33.340021
  var nextHour = now.add(new Duration(hours: hours));
  var roundedHour = DateTime(nextHour.year, nextHour.month, nextHour.day, nextHour.hour);
  return roundedHour;
}


//check if next hour is in the time range from prefs
bool isInTimeRange(Preference preferences, DateTime nextHour){
  var rangeStart = preferences.rangeStartMin; //change tbe method type in the preference.dart
  var rangeEnd = preferences.rangeEndMin;
  var nextHourInMinutes = nextHour.hour*60 + nextHour.minute;

  if (nextHourInMinutes >= rangeStart && nextHourInMinutes <= rangeEnd) {
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

scheduleNotification(String message, DateTime notificationTime, AppPreferences appPreferences) {
  var now = DateTime.now();
  // notificationTime = now.add(Duration(minutes: 1));
  print("Will show '$message' at $notificationTime");

  // schedule the time to show notification
  Workmanager.registerOneOffTask("Notification_"+notificationTime.toString(),
      "NotificationTask",
      initialDelay: notificationTime.difference(now),
      inputData: {'message': message},
      tag: "scheduledNotification" //for cancelling notification
  );

  // save notification time into preferences
  appPreferences.setNotificationScheduledTime(notificationTime);
}


//check the weather for the next hour

//check if the user has already run

//check when to send a notification from prefs

//schedule the notifications based on user prefs

//show notification in advance

