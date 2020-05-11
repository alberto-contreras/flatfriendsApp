import 'package:flatfriendsapp/models/Message.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MessageModel _message;
  var ioConnection;
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
              _sendButton(),
              Text(sharedData.getMessages().toString())
              // _receivedMessages()
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
    return FlatButton(onPressed: () async {
      print('Dentro Chat');
      if (sharedData.getUser().getIdPiso() != null) {
        print('antes de llamar initChatService');
        await chatService.initChatService(sharedData.getUser().getIdPiso());
        this.ioConnection = chatService.onMessage();
        // Navigator.pushReplacementNamed(context, '/chat');
      }
      else {
        //Alert password or email incorrect
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return Text(
                  'Para acceder a un chat has de pertenecer a un piso.');
            });
      }
    },
        child: Text('Chat'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _sendButton() {
    return FlatButton(onPressed: () async {
      print('mandando mensaje');
      if (sharedData.getUser().getIdPiso() != null) {
        print('antes de mandar mensaje');
        MessageModel _message = new MessageModel();
        _message.setRoom(sharedData.getUser().getIdPiso());
        _message.setContent('Hola');
        _message.setFromUser(sharedData.getUser().getFirstname());
        _message.setDate(DateTime.now().toString());
        await chatService.sendMessage(_message);
        // Navigator.pushReplacementNamed(context, '/chat');
      }
      else {
        //Alert password or email incorrect
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return Text(
                  'Para acceder a un chat has de pertenecer a un piso.');
            });
      }
    },
        child: Text('Send Message'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

//  Widget _receivedMessages() {
//    sharedData.setMessage('Chat:');
//    return ListView.separated(
//      padding: const EdgeInsets.all(8),
//      itemCount: sharedData.getMessages().length,
//      itemBuilder: (BuildContext context, int index) {
//        return Container(
//          height: 50,
//          child: Center(
//              child: Text('Entry ${sharedData.getMessages()[index]}')),
//        );
//      },
//      separatorBuilder: (BuildContext context, int index) => const Divider(),
//    );
//  }
}
