import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {

  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(100, 100, 100, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image(image: AssetImage('graphics/splashlogo.png'))
            SizedBox(
              width: 400.0,
              child: ColorizeAnimatedTextKit(
                  onTap: () {
                    print("Tap Event");
                  },
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
            )
          ],
        ),
      ),

    );
  }
}
