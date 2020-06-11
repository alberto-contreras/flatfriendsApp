import 'package:flatfriendsapp/pages/available_flats_page.dart';
import 'package:flatfriendsapp/pages/chat_page.dart';
import 'package:flatfriendsapp/pages/eventDetails_page.dart';
import 'package:flatfriendsapp/pages/event_page.dart';
import 'package:flatfriendsapp/pages/flat_attriubutes_update.dart';
import 'package:flatfriendsapp/pages/ranking_tasks.dart';
import 'package:flatfriendsapp/pages/task_page.dart';
import 'package:flatfriendsapp/pages/flat_page.dart';
import 'package:flatfriendsapp/pages/home_page.dart';
import 'package:flatfriendsapp/pages/login_page.dart';
import 'package:flatfriendsapp/pages/register_event_page.dart';
import 'package:flatfriendsapp/pages/register_task_page.dart';
import 'package:flatfriendsapp/pages/register_flat_page.dart';
import 'package:flatfriendsapp/pages/register_page.dart';
import 'package:flatfriendsapp/pages/splash_page.dart';
import 'package:flatfriendsapp/pages/user_attributes_update.dart';
import 'package:flatfriendsapp/pages/user_pass_update_page.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flatfriendsapp/pages/user_settings_page.dart';
import 'package:flatfriendsapp/pages/tasks_stats.dart';
import 'package:flatfriendsapp/pages/user_settings_page.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flatfriendsapp/pages/debt_page.dart';
import 'package:flatfriendsapp/pages/register_debt_page.dart';
import 'package:flatfriendsapp/pages/debtDetails_page.dart';
import 'package:flatfriendsapp/pages/yourTask_stats.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flat & Friends',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: { //This property is a Map Object where we pass key value
        // Main pages
        '/home':(context) => Home(), //Basic route context-> where we are we execute a function in this case we load all the data
        '/splash': (context) => Splash(),
        '/login':(context) => Login(),
        '/register': (context) => Register(),

        //  User pages
        '/user': (context) => User(),
        '/userSettings': (context) => UserSettings(),
        '/userUpdatePassword': (context) => UserUpdatePassword(),
        '/userUpdateAttributes': (context) => UserUpdateAttributes(),

        //  Flat pages
        '/flat': (context) => Flat(),
        '/regflat': (context) => RegisterFlat(),
        '/flatUpdateAttributes': (context) => FlatUpdateAttributes(),

        // Miscellanea
        '/chat': (context) => Chat(),
        '/event': (context) => Event(),
        '/regevent': (context) => RegisterEvent(),
        '/task': (context) => Task(),
        '/regtask': (context) => RegisterTask(),
        '/eventDetails': (context) => EventDetails(),
        '/availableFlats': (context) => AvailableFlats(),
        '/debt': (context) => Debt(),
        '/regdebt': (context) => RegisterDebt(),
        '/debtDetails': (context) => DebtDetails(),
        '/stats':(context) => TaskStats(),
        '/rankingTasks':(context) => RankingTasks(),
        '/yourTaskStats':(context) => YourTaskStats(),
      },
    );
  }
}