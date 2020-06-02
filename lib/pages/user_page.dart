import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/transitions/horizontal_transition_left_to_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'flat_page.dart';
import 'home_page.dart';

class User extends StatefulWidget {
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  SharedData sharedData = SharedData.getInstance();
  int _selectedIndex = 0;
  static const TextStyle tilesStyle = TextStyle(
    fontSize: 30, fontWeight: FontWeight.bold, );
  static const TextStyle inMainCardStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent);
  static const TextStyle inMainCardInfoStyle = TextStyle(
      fontSize: 18, color: Colors.black, fontStyle: FontStyle.italic);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
        actions: <Widget>[
          _settingsPopUpMenu(),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/userSettings');
                },
                child: Icon(
                  Icons.settings,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.only(left: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ColorizeAnimatedTextKit(
                text: [
                  "Perfil de usuario:",
                ],
                textStyle: tilesStyle,
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.yellow,
                  Colors.red,
                ],
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
            ),
            _showUserData(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('User'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Flat'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  // Actions to do when an item from bottom nav bar is pushed
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          Navigator.of(context).pop();
          Navigator.push(context,
              EnterRightExitLeftRoute(exitPage: User(), enterPage: Home()));
          break;
        case 2:
          Navigator.of(context).pop();
          Navigator.push(context,
              EnterRightExitLeftRoute(exitPage: User(), enterPage: Flat()));
          break;
      }
    });
  }

  Widget _settingsPopUpMenu() => PopupMenuButton(
    itemBuilder: (context) => [
      PopupMenuItem(child: Text('Ajustes'),
      value: 0,),
      PopupMenuItem(child: Text('Cerrar sesión'),
        value: 1,)
      ],
    icon: Icon(Icons.settings),
    onSelected: (value) {
      switch (value){
        case 0: {
          print('Aquí iríamos a los ajustes de usuario.');
        }
        break;
      case 1: {
      print('Cerraríamos la sesión.');
      }
      break;
    }

    },

  );

  Widget _showUserData() {
    print('Showing user data.');
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: EdgeInsets.only(right: 70, left: 15, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (sharedData.getUrlUserAvatar() != null) Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(sharedData.getUrlUserAvatar()),
                  ),
                  SizedBox(height: 16,)
                ],
              ),

              Text('Nombre de usuario:', style: inMainCardStyle,),
              SizedBox(height: 5),
              Row(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      left: 1.0,
                      top: 2.0,
                      child: Icon(Icons.person, color: Colors.black26),
                    ),
                    Icon(Icons.person, color: Colors.white,),
                  ],
                ),

                Text('  ' + sharedData.getUser().getFirstname() + " " +
                    sharedData.getUser().getLastname(), style: inMainCardInfoStyle,),
              ],),

              SizedBox(height: 10),
              Text('Correo electrónico:', style: inMainCardStyle),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        left: 1.0,
                        top: 2.0,
                        child: Icon(Icons.email, color: Colors.black26),
                      ),
                      Icon(Icons.email, color: Colors.white,),
                    ],
                  ),
                  SizedBox(width: 10,),
                  Text(sharedData.getUser().getEmail(), style: inMainCardInfoStyle,),
                ],
              ),

              if (sharedData.getUser().getPhoneNumber() != null) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text('Número de teléfono:', style: inMainCardStyle),
                  SizedBox(height: 5),
                 Row(
                   children: <Widget>[
                     Stack(
                       children: <Widget>[
                         Positioned(
                           left: 1.0,
                           top: 2.0,
                           child: Icon(Icons.phone, color: Colors.black26),
                         ),
                         Icon(Icons.phone, color: Colors.white,),
                       ],
                     ),
                     Text(sharedData.getUser().getPhoneNumber(), style: inMainCardInfoStyle,),
                   ],
                 ),
                ],
              ),

            ],
          ),
        )
    );
  }
}
