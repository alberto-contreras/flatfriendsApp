import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flutter/material.dart';

class User extends StatefulWidget {
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {

  SharedData sharedData = SharedData.getInstance();
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
        actions: <Widget>[
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
            _showUserData(),
            _showUserData2(),
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
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/flat');
          break;
      }
    });
  }

  Widget _showUserData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Perfil de usuario:', style: optionStyle),
        Divider(height: 15, color: Colors.white),
        Text('Nombre de usuario:', style: labelStyle,),
        Text(sharedData.getUser().getFirstname() + " " +
            sharedData.getUser().getLastname(), textScaleFactor: 1.5,),
        Divider(height: 10, color: Colors.white),
        Text('Correo electrónico:', style: labelStyle),
        Text(sharedData.getUser().getEmail(), textScaleFactor: 1.5,),
        Divider(height: 10, color: Colors.white),
      ],
    );
  }

  Widget _showUserData2() {
    if (sharedData.getUser().getPhoneNumber() != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Número de teléfono:', style: labelStyle),
          Text('' + sharedData.getUser().getPhoneNumber().toString(),
            textScaleFactor: 1.5,),
          Divider(height: 10, color: Colors.white,),
        ],
      );
    }
    if (sharedData.getUser().getIdPiso() != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Identificador del piso:', style: labelStyle),
          Text('' + sharedData.getUser().getIdPiso(), textScaleFactor: 1.5,),
        ],
      );
    }
    else {
      print('The user do not has any flat registered. Showing button.');
      return FlatButton(onPressed: () {
        Navigator.pushNamed(context, '/regflat');
      },
          child: Text('Registrat tu piso'),
          shape: StadiumBorder(),
          color: Colors.blue,
          textColor: Colors.white);
    }
  }
}
