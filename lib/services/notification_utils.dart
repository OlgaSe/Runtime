// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
//
//
// class NotificationUtils {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   AndroidInitializationSettings androidInitializationSettings;
//   IOSInitializationSettings iosInitializationSettings;
//   InitializationSettings initializationSettings;
//
//   void initialize() {
//     initializing();
//   }
//
//   void initializing() async {
//     androidInitializationSettings = AndroidInitializationSettings('app_icon');
//     iosInitializationSettings = IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     initializationSettings = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
//   }
//
//   void showNotifications(String message) async {
//     await notification(message);
//   }
//
//
//   Future<void> notification(String message) async{
//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//         'Channel_ID',
//         'Channel title',
//         'Channel body',
//         priority: Priority.high,
//         importance: Importance.max,
//         ticker: 'Test'
//     );
//     IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
//
//     NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(0, 'Ready for a run? 🏃', message, notificationDetails);
//   }
//
//
//   Future onSelectNotification(String payLoad) {
//     if(payLoad != null){
//       print(payLoad);
//     }
//
//     // set navigator to the the home page
//     // Navigator.push(context, MaterialPageRoute(builder: (context) {
//     //   return HomePage();
//     // }));
//   }
//
//
//   Future onDidReceiveLocalNotification(int id, String title, String body, String payLoad) async {
//     return CupertinoAlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: <Widget> [
//         CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: () {
//               print("");
//             },
//             child: Text("Okay")),
//       ],);
//
//   }
// }
//
//
// //
// // @override
// // Widget build(BuildContext context) {
// //   return Container();
// // }