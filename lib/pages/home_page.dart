import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SharedData sharedData = SharedData.getInstance();
class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var ioConnection;
  FlatService flatService = new FlatService();
  ChatService chatService = new ChatService();
  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              _chatButton(),
              _eventButton(),
            ],
          )
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
        case 2:
          Navigator.pushReplacementNamed(context, '/flat');
          break;
      }
    });
  }

  Widget _chatButton() {
    return FlatButton(onPressed: () {
      if (sharedData.chatRunning == true){
        Navigator.pushNamed(context, '/chat');
      }
    },
        child: Text('Chat'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _eventButton() {
    return FlatButton(onPressed: () async {

       await flatService.getEventFlat();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/event');

    },
        child: Text('Eventos'),
        shape: StadiumBorder(),
        color: Colors.purple,
        textColor: Colors.white);
  }
}
