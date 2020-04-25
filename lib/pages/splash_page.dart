import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatelessWidget {

  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('graphics/splashlogo.png'))
            ],
          ),
      ),

    );
  }
}
