import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flutter/material.dart';

SharedData sharedData = SharedData.getInstance();

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = new TextEditingController();
  int _numMessages;
  ChatMessageModel _messageToSend = new ChatMessageModel();
  List<Widget> messagesList = new List<Widget>();
  static const TextStyle nameStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle messageStyle = TextStyle(
    fontSize: 16,);

  @override
  Widget build(BuildContext context) {
    List<Widget> messagesList = new List<Widget>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.teal,
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),

                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.83,
                child: ListView(

                  reverse: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    _messages(),
//                    Padding(padding: EdgeInsets.all(5.00)),
                  ],
                ),
              ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: _textMessage(),
                    width: 280.0,
                    height: 40.0,
                  ),
                  // _textMessage(),
                  _sendButton()
                ],
              ),
            ],
          ),
        )
    );
  }

  void initState() {
    super.initState();
    _numMessages = sharedData.getMessages().length;

    print('en el initState los mensajes:' + sharedData.getMessages().toString());
    sharedData.getMessages().forEach((message) {
      print(message.getMessage());
      if (sharedData.getUser().getFirstname() == message.getUserName()) {
        this.messagesList.add(Bubble(
            margin: BubbleEdges.only(
                top: 10),
            alignment: Alignment.topRight,
            nip: BubbleNip.rightTop,
            color: Color.fromRGBO(225, 255, 199, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(message.getUserName() + ':', style: nameStyle,),
                Text(message.getMessage(), style: messageStyle)
              ],
            )
        ));
      }
      else {
        this.messagesList.add(
            Bubble(
              margin: BubbleEdges.only(top: 10),
              alignment: Alignment.topLeft,
              nipWidth: 8,
              nipHeight: 24,
              nip: BubbleNip.leftTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(message.getUserName() + ':', style: nameStyle,),
                  Text(message.getMessage(), style: messageStyle)
                ],
              ),
            ));
      }
    });
  }

  Widget sendMessageTab () {
    return Container(
      height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 30.0,
              width: MediaQuery.of(context).size.width - 166.0,
              child: _textMessage(),
            ),
            Container(
              width: 130.0,
                child: _sendButton()
            )
          ],
        )
    );
  }

  Widget messagesView () {
    return Container(
      height: MediaQuery.of(context).size.height - 140.0,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Column(
              children: messagesList
          ),
//                    Padding(padding: EdgeInsets.all(5.00)),
        ],
      ),
    );
  }

  Widget _messages() {
//    sharedData.getMessages().forEach((message) {
//      print(message.getMessage());
//      if (sharedData.getUser().getFirstname() == message.getUserName()) {
//        this.messagesList.add(Bubble(
//            margin: BubbleEdges.only(
//                top: 10),
//            alignment: Alignment.topRight,
//            nip: BubbleNip.rightTop,
//            color: Color.fromRGBO(225, 255, 199, 1.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text(message.getUserName() + ':', style: nameStyle,),
//                Text(message.getMessage(), style: messageStyle)
//              ],
//            )
//        ));
//      }
//      else {
//        this.messagesList.add(
//            Bubble(
//              margin: BubbleEdges.only(top: 10),
//              alignment: Alignment.topLeft,
//              nipWidth: 8,
//              nipHeight: 24,
//              nip: BubbleNip.leftTop,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(message.getUserName() + ':', style: nameStyle,),
//                  Text(message.getMessage(), style: messageStyle)
//                ],
//              ),
//            ));
//      }
//    });
//
  while (_numMessages < sharedData.getMessages().length) {
      setState(() {
        if (sharedData.getUser().getFirstname() == sharedData.getMessages()[_numMessages].getUserName()) {
          this.messagesList.add(Bubble(
              margin: BubbleEdges.only(
                  top: 10),
              alignment: Alignment.topRight,
              nip: BubbleNip.rightTop,
              color: Color.fromRGBO(225, 255, 199, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(sharedData.getMessages()[_numMessages].getUserName() + ':', style: nameStyle,),
                  Text(sharedData.getMessages()[_numMessages].getMessage(), style: messageStyle)
                ],
              )
          ));
        }
        else {
          this.messagesList.add(
              Bubble(
                margin: BubbleEdges.only(top: 10),
                alignment: Alignment.topLeft,
                nipWidth: 8,
                nipHeight: 24,
                nip: BubbleNip.leftTop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sharedData.getMessages()[_numMessages].getUserName() +
                          ':',
                      style: nameStyle,),
                    Text(sharedData.getMessages()[_numMessages].getMessage(),
                        style: messageStyle)
                  ],
                ),
              ));
        }
      });
      _numMessages++;
  }
    print('He cargado la lista de mensajes');
    return Column(
        children: messagesList
    );
  }

  Widget _textMessage() {
    return Container(
          child: TextField(
            controller: messageController,
            keyboardType: TextInputType.text,
          )
      );
  }


  Widget _sendButton() {
    return FlatButton(onPressed: () async {
        print('mandando mensaje');
        if (messageController.text != '' && messageController.text != null) {
          print('antes de mandar mensaje');
          _messageToSend.setChatRoom(sharedData.getUser().getIdPiso());
          _messageToSend.setMessage(messageController.text);
          _messageToSend.setUserName(sharedData.getUser().getFirstname());
          _messageToSend.setDateTime(DateTime.now().toString());
          await sharedData.chatService.sendMessage(_messageToSend);
          // Navigator.pushReplacementNamed(context, '/chat');
          messageController.clear();
        }

      },
          child: Text('Send Message'),
          shape: StadiumBorder(),
          color: Colors.green,
          textColor: Colors.white);
  }
}
