import 'package:flutter/material.dart';
import '../services/location.dart';
import '../services/networking.dart';


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

    @override
    void initState() {
      super.initState();

    getLocationData();
  }

    void getLocationData() async {
          Location location = Location();
          await location.getCurrentLocation();
          latitude = location.latitude;
          longitude = location.longitude;
          print(latitude);
          print(longitude);

          NetworkHelper networkHelper = NetworkHelper('https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=imperial');
      //save our response from api to weatherData var which we will use in the location screen.dart in the text widget
      //https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=imperial

      var weatherData = await networkHelper.getData();

      // var time = weatherData['hourly']['dt'];
      // var temperature = weatherData['hourly']['temp'];
      // var main = weatherData['hourly']['weather']['main'];
      // var icon = weatherData['hourly']['weather']['icon'];
      //
      // print(time);
      // print(temperature);
      // print(main);
      // print(icon);
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
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/background.png',),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Time',
                    ),
                    Text(
                      'Weather icon',
                    ),
                    Text(
                      'Temperature',
                      // style: kTempTextStyle,
                    ),
                    Text(
                      'Main',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Time'),
                    Text('Weather icon'),
                    Text('temperature°'),
                    Text('Main'),
                  ],
                ),
          ],
        ),
      ]),
    ),
    );
  }
}
