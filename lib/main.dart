import 'package:flatfriendsapp/pages/chat_page.dart';
import 'package:flatfriendsapp/pages/eventDetails_page.dart';
import 'package:flatfriendsapp/pages/event_page.dart';
import 'package:flatfriendsapp/pages/flat_page.dart';
import 'package:flatfriendsapp/pages/home_page.dart';
import 'package:flatfriendsapp/pages/login_page.dart';
import 'package:flatfriendsapp/pages/register_event_page.dart';
import 'package:flatfriendsapp/pages/register_flat_page.dart';
import 'package:flatfriendsapp/pages/register_page.dart';
import 'package:flatfriendsapp/pages/splash_page.dart';
import 'package:flatfriendsapp/pages/user_settings_page.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flat & Friends',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: { //This property is a Map Object where we pass key value
        '/home':(context) => Home(), //Basic route context-> where we are we execute a function in this case we load all the data
        '/splash': (context) => Splash(),
        '/login':(context) => Login(),
        '/register': (context) => Register(),
        '/user': (context) => User(),
        '/flat': (context) => Flat(),
        '/regflat': (context) => RegisterFlat(),
        '/userSettings': (context) => UserSettings(),
        '/chat': (context) => Chat(),
        '/event': (context) => Event(),
        '/regevent': (context) => RegisterEvent(),
        '/eventDetails': (context) => EventDetails(),
      },
    );
  }
}