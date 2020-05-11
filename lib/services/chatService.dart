import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Chat.dart';
import 'package:flatfriendsapp/models/Message.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

SharedData sharedData = SharedData.getInstance();

class ChatService {
  Socket socket = io('http://10.0.2.2:8080', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'extraHeaders': {'foo': 'bar'} // optional
  });

  initChatService(String flatId) {
    print('initiating chat');
    socket.connect();
    socket.emit('joinToTheRoom', flatId);
  }

//  Future<MessageModel> onMessage() {
//    var message;
//    socket.on('message', (data) {
//      message = data as MessageModel;
//    });
//    return message;
//  }

  onMessage() {
    socket.on('message', (data) => sharedData.setMessage(data));
  }

  sendMessage(MessageModel message) {
    String json = '{"room": "' + message.getRoom() + '", "content": "' + message.getContent() + '", "fromUser": "' + message.getFromUser() + '", "date": "' + message.getDate() +'"}';
    print(json);
    socket.emit('roomMessage', json);
  }
}