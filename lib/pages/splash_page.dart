import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {

  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
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
}
