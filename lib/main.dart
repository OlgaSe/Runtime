import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runtime/screens/homepage.dart';
import 'package:runtime/screens/registration_screen.dart';
import 'package:runtime/services/app_prefs.dart';
import 'package:runtime/services/hourly_work.dart';
import 'package:runtime/services/notification.dart';
import 'package:workmanager/workmanager.dart';
import 'package:runtime/services/notification.dart';

import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
// import 'package:runtime/services/notification_utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var currentTime = DateTime.now();
  print("Starting app at $currentTime");
  NotificationUtils.initialize();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager.registerPeriodicTask('periodic', 'periodicTask',
    frequency: Duration(minutes: 15),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );

  AwesomeNotifications().actionStream.listen((receivedNotification) {
    var pressedButtonKey = receivedNotification.buttonKeyPressed;
    print("User pressed button: $pressedButtonKey");
    if (pressedButtonKey == 'ACCEPT') {
      onPressedAccept();
    } else if (pressedButtonKey == 'CANCEL') {
      onPressedCancel();
    } else {
      print('Unknown button $pressedButtonKey');
    }
  });

  runApp(MyApp());
}


void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print("Got callback");

    if (task == 'periodicTask') {
      print("Got periodicTask");
      try {
        await hourlyWork();
      } catch (e) {
        print(e);
      }
    } else if (task == 'NotificationTask' ) {
      print("Got NotificationTask");
      print("Calling initialize");

      print("Showing notification");
      NotificationUtils.showNotifications(inputData["message"]);
    } else {
      print("Unknown task! $task");
    }

    return Future.value(true);
  });
}

void onPressedAccept() async {
  var appPreferences = await AppPreferences.loadPreferences();
  appPreferences.setLastRunTime(DateTime.now());
  Workmanager.cancelByTag('scheduledNotification');
}

void onPressedCancel() async {
  var appPreferences = await AppPreferences.loadPreferences();
  appPreferences.setCancelNotificationsTime(DateTime.now());
  Workmanager.cancelByTag('scheduledNotification');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runtime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,

        fontFamily: 'Quicksand',

        textTheme: TextTheme(
          // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 16.0,  fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
        ),
      ),
      // home: HomePage(title: 'Runtime Home Page'),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomePage.id: (context) => HomePage(title: 'Runtime'),
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
