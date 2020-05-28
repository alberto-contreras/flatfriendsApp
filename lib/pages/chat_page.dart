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
  ChatMessageModel _messageToSend = new ChatMessageModel();
  List<Widget> messagesList = new List<Widget>();

  static const TextStyle nameStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle messageStyle = TextStyle(
    fontSize: 16,);

  @override
  Widget build(BuildContext context) {
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
                        .height * 0.80,
                    child: StreamBuilder(
                      stream: sharedData.chatStream.stream,
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.data != null) {
                          messagesList = [];
                          snapshot.data.forEach( (message) {
                            messagesList.add(
                                Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  alignment: sharedData.getUser().getFirstname() == message.getUserName() ? Alignment.topRight : Alignment.topLeft,
                                  color: sharedData.getUser().getFirstname() == message.getUserName() ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white,
                                  nip: sharedData.getUser().getFirstname() == message.getUserName() ? BubbleNip.rightTop : BubbleNip.leftTop,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(message.getUserName() + ':', style: nameStyle,),
                                      Text(message.getMessage(), style: messageStyle)
                                    ],
                                  ),
                                )
                            );
                          });
                        } else {
                          sharedData.getMessages().forEach((message) {
                            print(message.getMessage());
                            messagesList.add(
                                Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  alignment: sharedData.getUser().getFirstname() == message.getUserName() ? Alignment.topRight : Alignment.topLeft,
                                  color: sharedData.getUser().getFirstname() == message.getUserName() ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white,
                                  nip: sharedData.getUser().getFirstname() == message.getUserName() ? BubbleNip.rightTop : BubbleNip.leftTop,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(message.getUserName() + ':', style: nameStyle,),
                                      Text(message.getMessage(), style: messageStyle)
                                    ],
                                  ),
                                )
                            );
                          });
                        }
                        return ListView(
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: messagesList
                        );
                      },
                    )
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: _textMessage(),
                    width: MediaQuery.of(context).size.width - 115,
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
        child: Text('Enviar'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }
}
