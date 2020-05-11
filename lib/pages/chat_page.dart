//import 'package:flatfriendsapp/globalData/sharedData.dart';
//import 'package:flutter/material.dart';
//
//class Chat extends StatefulWidget {
//  _ChatState createState() => _ChatState();
//}
//
//class _ChatState extends State<Chat> {
//  SharedData sharedData = SharedData.getInstance();
//  int _selectedIndex = 2;
//  static const TextStyle optionStyle = TextStyle(
//      fontSize: 30, fontWeight: FontWeight.bold);
//  static const TextStyle labelStyle = TextStyle(
//      fontSize: 20, fontWeight: FontWeight.bold);
//
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Flat & Friends'),
//      ),
//      body: _showChat(),
//
//      bottomNavigationBar: BottomNavigationBar(
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.person),
//            title: Text('User'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.business),
//            title: Text('Flat'),
//          ),
//        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
//        onTap: _onItemTapped,
//      ),
//    );
//  }
//
//  // Do an action depending on the pushed button from bottom nav bar
//  void _onItemTapped(int index) {
//    setState(() {
//      _selectedIndex = index;
//      switch (_selectedIndex) {
//        case 0:
//          Navigator.pushReplacementNamed(context, '/user');
//          break;
//        case 1:
//          Navigator.pushReplacementNamed(context, '/home');
//          break;
//      }
//    });
//  }


//  Widget _showChat() {
//    if (sharedData.getFlat() != null) {
//      return //TODO definir el Widget chat;
//    } else {
//      return Text('Para acceder a un chat registrate en un piso.',style: labelStyle);
//    }
//  }
//}