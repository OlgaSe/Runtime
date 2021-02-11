import 'package:flutter/material.dart';
import 'package:runtime/services/hourly_work.dart';
import 'package:runtime/services/notification_utils.dart';
import '../services/location.dart';
import '../services/networking.dart';
import '../services/weather.dart';
import '../screens/settings.dart';
import '../services/hourly_work.dart';
import 'package:intl/intl.dart';




const apiKey = '4cc0b548d4ce485830092023fcfeea03';

class HomePage extends StatefulWidget {
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
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
    double latitude;
    double longitude;
    dynamic weatherData;
    Weather weather;
    NotificationUtils notificationUtils = NotificationUtils();


    @override
    void initState() {
      super.initState();

      updateLocationData();
      notificationUtils.initialize();
    }



  void updateLocationData() async {
    // Location location = Location();
    // await location.getCurrentLocation();
    // latitude = location.latitude;
    // longitude = location.longitude;
    // print(latitude);
    // print(longitude);
    //
    // NetworkHelper networkHelper = NetworkHelper(
    //     'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=imperial');
    // //save our response from api to weatherData var which we will use in the location screen.dart in the text widget
    // //https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=imperial
    //
    // var weatherDataResponse = await networkHelper.getData();
    //
    // var time = weatherDataResponse['hourly'][0]['dt'];
    // // var temperature = weatherData['hourly']['temp'];
    // // var main = weatherData['hourly']['weather']['main'];
    // // var icon = weatherData['hourly']['weather']['icon'];
    //
    // print(time);
    // // print(temperature);
    // // print(main);
    // // print(icon);

    var loadedWeather = await Weather.getWeather();
    setState(() {
      weather = loadedWeather;
      weatherData = weather.getRawWeatherData();
      //weatherData = weatherDataResponse;
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
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
              return {'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(nextTimeSlot()),
            ),
            Image.asset(
            'images/background.png',
            width: 400.0,
            height: 350.0,),
            FlatButton(
                color: Colors.blue,
                onPressed: () => hourlyWork(debug: true),
                child: Text(
                  "Show notification",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                )),
            getWeatherTable(context),
      ]),
    ),
    );
  }
    void handleClick(String choice) {
      if(choice == 'Settings') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingsScreen();
        }));
      }
    }

    String nextTimeSlot() {
      var text = '';

      if (weather == null) {
        return "";
      }

      var nextGoodWeather = weather.getNextHourGoodWeather();
      if (nextGoodWeather != null) {
        var nextGoodWeatherHour = DateTime.fromMillisecondsSinceEpoch(nextGoodWeather['dt'] * 1000);
        var nextHourString = DateFormat.Hm().format(nextGoodWeatherHour);
        text = 'Next time for run is at: $nextHourString';
        return text;
      } else {
        return "There is no good time for running today";
      }
    }




}


