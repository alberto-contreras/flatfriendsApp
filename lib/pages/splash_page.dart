import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedData sharedData = SharedData.getInstance();

class Splash extends StatelessWidget {
  UserModel userToLog = new UserModel();
  UserService userService = new UserService();
  FlatService flatService = new FlatService();

  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), () {
      // Function to see if shared preferences have content or not
      _loadSharedPreferences(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        color: Color.fromRGBO(100, 100, 100, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Image(image: AssetImage('graphics/splashlogo.png'))
            ColorizeAnimatedTextKit(
                text: [
                  "Flat&Friends"
                ],
                textStyle: TextStyle(
                    fontSize: 70.0,
                    fontFamily: "Horizon"
                ),
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.yellow,
                  Colors.red,
                ],
                textAlign: TextAlign.center,
                alignment: AlignmentDirectional.center // or Alignment.topLeft
            ),
          ],
        ),
      ),

    );
  }

  // Function to see if shared preferences have content or not
  void _loadSharedPreferences(final context) async {
    final prefs = await SharedPreferences.getInstance();

    // If shared preferences are empty, we obtain a 0
    // If 0 --> regular log in, If != 0 --> auto log in
    final credentials = prefs.getString('user') ?? 0;
    if (credentials != 0) {
      userToLog.setEmail(prefs.getString('user'));
      userToLog.setPassword(prefs.getString('password'));
      userToLog.setGoogleAuth(prefs.getBool('googleAuth'));
      int res = await userService.logUser(userToLog);
      if (res == 0) {
        if (sharedData.getUser().getIdPiso() != null && sharedData
            .getUser()
            .getIdPiso()
            .length == 24) {
          print('antes de llamar initChatService');
          await sharedData.chatService.initChatService(
              sharedData.getUser().getIdPiso());
          sharedData.chatService.onMessage();
          sharedData.chatRunning = true;
          int getFlat = await flatService.getFlat();
          int getTenants = await flatService.getTenantsFlat();
          if (getFlat == 0 && getFlat == getTenants) {
            print(
                'Success getting Flat Data and Tenants Data through Flat&Friends Logging In.');
          }
        }
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
    else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

}
