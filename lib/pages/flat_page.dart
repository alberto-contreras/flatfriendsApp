import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class Flat extends StatefulWidget {
  _FlatState createState() => _FlatState();
}

class _FlatState extends State<Flat> {
  SharedData sharedData = SharedData.getInstance();
  int _selectedIndex = 2;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
      ),
      body: Padding(padding: const EdgeInsets.only(left: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Perfil del piso:', style: optionStyle),
            Divider(height: 15, color: Colors.white),
              _showFlatData(),
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

  // Do an action depending on the pushed button from bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushReplacementNamed(context, '/user');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/home');
          break;
      }
    });
  }


  Widget _showFlatData() {
    if (sharedData.getFlat() != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Nombre del Piso:', style: labelStyle ),
          Text('' + sharedData.getFlat().getName().toString(),
            textScaleFactor: 1.5,),
          Divider(height: 10, color: Colors.white,),
          Text('Descripción del Piso:', style: labelStyle ),
          Text('' + sharedData.getFlat().getDescription().toString(),
            textScaleFactor: 1.5,),
          Divider(height: 10, color: Colors.white,),
          Text('Numero maximo de inquilinos:', style: labelStyle ),
          Text('' + sharedData.getFlat().getMaxPersons().toString(),
            textScaleFactor: 1.5,),
          Divider(height: 10, color: Colors.white,),
        ],
      );
    }
    else {
      return Text('No estas registrado en un piso.',style: labelStyle);
    }
  }

}