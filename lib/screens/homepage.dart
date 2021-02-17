
import 'package:flutter/material.dart';
import 'package:runtime/screens/welcome_screen.dart';
import 'package:runtime/services/hourly_work.dart';
import '../services/weather.dart';
import '../screens/settings.dart';
import '../services/hourly_work.dart';
import 'package:intl/intl.dart';
import 'package:runtime/services/preference.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget {

  static const id = 'homepage';

  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    double latitude;
    double longitude;
    dynamic weatherData;
    Weather weather;
    Preference preferences;

    final _auth = FirebaseAuth.instance;
    User loggedInUser;

    @override
    void initState() {
      super.initState();

      loadPreference();
      updateLocationData();
      getCurrentUser();
    }


    void getCurrentUser() {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          loggedInUser = user;
          print(loggedInUser.email);
        }
      } catch (e) {
        print(e);
      }
    }

  void updateLocationData() async {
    var loadedWeather = await Weather.getWeather();

    setState(() {
      weather = loadedWeather;
      weatherData = weather.getRawWeatherData();
      //weatherData = weatherDataResponse;
    });
  }

  void loadPreference() async {
    var userPreferences = await Preference.loadPreference();

    setState(() {
      preferences = userPreferences;
    });
  }

  Widget getWeatherTable(BuildContext context) {
    var rows = [
      TableRow(key: ValueKey(0), children: <Widget>[
        Text('Time',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Weather',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        Text('Temp (F)°',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Main',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ])
    ];


    if (weatherData != null) {
      for (var i = 0; i < weatherData['hourly'].length-36; i++) {

        // weatherData['hourly'].forEach((hourlyData) {
        var hourlyData = weatherData['hourly'][i];
        var date = DateTime.fromMillisecondsSinceEpoch(hourlyData['dt'] * 1000);
        rows.add(TableRow(key: ValueKey(hourlyData['dt']), children: <Widget>[
          Text(date.hour.toString() + ':00',
            textAlign: TextAlign.center,
          ),
          Text(WeatherModel.getWeatherIcon(hourlyData['weather'][0]['id']),
            textAlign: TextAlign.center,
          ),
          Text(hourlyData['temp'].toInt().toString(),
            textAlign: TextAlign.center,),
          Text(hourlyData['weather'][0]['main'],
            textAlign: TextAlign.center,),
        ]));
      }
    }

    return Table(
      border: TableBorder(verticalInside: BorderSide()),
      children: rows,
    );
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
              return {'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.jpg'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                child: Text(
                    nextTimeSlot(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                child: Text(dailyForecast()),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Image.asset(
                    'images/background.png',
                    width: 380.0,
                    height: 340.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Text(currentTemp()),
                  ),
                ],
              ),


              // FlatButton(
              //     color: Colors.blue,
              //     onPressed: () => hourlyWork(debug: true),
              //     child: Text(
              //       "Show notification",
              //       style: TextStyle(fontSize: 20.0, color: Colors.white),
              //     )),

              getWeatherTable(context),
      ]),
        ),
    ),
    );
  }
    void handleClick(String choice) {
      if (choice == 'Settings') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingsScreen();
        }));
      } else if (choice == 'Logout') {
        _auth.signOut();
        Navigator.popAndPushNamed(context, WelcomeScreen.id);
      }
    }

    String nextTimeSlot() {
      var text = '';

      if (weather == null || preferences==null) {
        return "";
      }

      var now = DateTime.now();
      var rangeEndSec = DateTime(now.year, now.month, now.day,
          preferences.rangeEndMin ~/ 60).millisecondsSinceEpoch / 1000;

      if (now.millisecondsSinceEpoch/1000>rangeEndSec) {
        // the day is over
        return "";
      }

      var nextGoodWeather = weather.getNextHourGoodWeather();
      if (nextGoodWeather != null && nextGoodWeather['dt'] < rangeEndSec) {
        var nextGoodWeatherHour = DateTime.fromMillisecondsSinceEpoch(nextGoodWeather['dt'] * 1000);
        var nextHourString = DateFormat.Hm().format(nextGoodWeatherHour);
        text = 'Next time for run is at: $nextHourString';
      }

      return text;
    }


    String dailyForecast() {
      if (preferences == null || weatherData == null) {
        return '';
      }

      var now = DateTime.now();
      var rangeStartSec = DateTime(now.year, now.month, now.day,
          preferences.rangeStartMin ~/ 60).millisecondsSinceEpoch / 1000 ;
      var rangeEndSec = DateTime(now.year, now.month, now.day,
          preferences.rangeEndMin ~/ 60).millisecondsSinceEpoch / 1000;

      int counter = 0;
      for (var i = 0; i < weatherData['hourly'].length; i++) {
        var hourlyData = weatherData['hourly'][i];
        if (rangeStartSec<=hourlyData['dt'] && hourlyData['dt']<=rangeEndSec
            && Weather.isGoodWeather(hourlyData)) {
            counter++;
        }
      }

      if (now.millisecondsSinceEpoch/1000 > rangeEndSec) {
        return "The day is over. Let's run tomorrow";
      } else if (counter == 0) {
        return 'Unfortunately, today there is no optimal time to run';
      } else if (counter < 2) {
        return 'Today there is the only one chance to go for a run!';
      } else if (counter < 3) {
        return 'Today it\'s just a few time slots good for a run';
      } else if (counter < 6){
        return 'Today there are some slots with good weather';
      } else {
        return 'Today is a perfect day to be outside. Enjoy it!';
      }
    }

    String currentTemp() {
      if (weatherData == null) {
        return  '';
      }
      int temp = weatherData['hourly'][0]['temp'].round();
      return  'Current temperature: ' +  temp.toString() + '°F';
    }
}


