import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/ui/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  //Initialize firebase and check if dark mode is activated
  @override
  _MyAppState createState() => _MyAppState();
}

///initialize Flutter local notification plugin
FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.notification != null) {
    showNotification(message.notification.title, message.notification.body);
  }
  // Or do other work.
}


///Show notification
Future<void> showNotification(String title, String description) async {
  var android = new AndroidNotificationDetails(
    'channel id',
    'channel NAME',
    'CHANNEL DESCRIPTION',
    priority: Priority.high,
    importance: Importance.max,
    playSound: true,
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: iOS);
  await _flutterLocalNotificationsPlugin.show(
      0, title, description, platform);
}


class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    ///Configure notifications: initialization for iOS and android
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    _flutterLocalNotificationsPlugin.initialize(initSetttings);
  }


  Future<bool> initializeApp() async {
    await Firebase.initializeApp();


    ///Initialize Firebase messaging
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    ///Request notifications permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    ///Show foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message.notification.title, message.notification.body);
      }
    });

    ///Show background notifications
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isDark = false;
    if (prefs.containsKey('isDark')) {
      isDark = prefs.getBool('isDark');
    }
    return isDark;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<ThemeModel>(
                      create: (context) =>
                          ThemeModel(
                              theme: (snapshot.data)
                                  ? ThemeModel.dark
                                  : ThemeModel.light)),
                  Provider<AuthBase>(create: (context) => Auth()),
                  Provider<Database>(create: (context) => FirestoreDatabase()),
                ],
                child: Consumer<ThemeModel>(
                  builder: (context, model, _) {
                    final auth = Provider.of<AuthBase>(context, listen: false);
                    final database = Provider.of<Database>(
                        context, listen: false);

                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: model.theme,
                      home: SplashScreen(auth: auth,
                        database: database,),
                      title: "Grocery Admin",
                    );
                  },
                ),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
              );
            }
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
