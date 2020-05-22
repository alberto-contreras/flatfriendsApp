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
          child:GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              _chatButton(),
              _eventButton(),
              _taskButton(),
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
    return FlatButton(
        onPressed: () {
          if (sharedData.chatRunning == true){
            Navigator.pushNamed(context, '/chat');
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.chat,
                color: Colors.white,
                size: 96.00,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Chat')
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.green,
        textColor: Colors.white
    );
  }

  Widget _eventButton() {
    return FlatButton(onPressed: () async {

      await flatService.getEventFlat();
      //print(sharedData.eventsFlat);
      Navigator.pushNamed(context, '/event');

    },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.local_bar,
                color: Colors.white,
                size: 96.00,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Events')
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.purple,
        textColor: Colors.white);
  }

  Widget _taskButton() {
    return FlatButton(onPressed: () async {

      await flatService.getTaskFlat();
      await flatService.getUsersFlatForTask();
      //print(sharedData.eventsFlat);
      Navigator.pushNamed(context, '/task');

    },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.today,
                color: Colors.white,
                size: 96.00,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Tasks')
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.red,
        textColor: Colors.white);
  }
}
