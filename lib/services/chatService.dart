import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/pages/chat_page.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

SharedData sharedData = SharedData.getInstance();

class ChatService {
  Socket socket = io('http://147.83.7.155:8080', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'extraHeaders': {'foo': 'bar'} // optional
  });

  initChatService(String flatId) {
    print('initiating chat');
    socket.connect();
    socket.emit('joinToTheRoom', flatId);
  }

  // The client receives a message
  onMessage() {
    print('Estamos donde mensaje recibido');
    socket.on('message', (data) {
      Map messageData = jsonDecode(data);
      ChatMessageModel chatMessage = new ChatMessageModel();
      chatMessage.setUserName(messageData['fromUser']);
      chatMessage.setMessage(messageData['content']);
      chatMessage.setDateTime(messageData['date']);
      print('Mensaje recibido de: ' + chatMessage.getUserName());
      sharedData.setMessage(chatMessage);
    });
  }

  // The client sends a message
  sendMessage(ChatMessageModel message) {
    String json = '{"room": "' + message.getChatRoom() + '", "content": "' + message.getMessage() + '", "fromUser": "' + message.getUserName() + '", "date": "' + message.getDateTime() +'"}';
    print('Envíamos un mensaje   '+message.getMessage());
    socket.emit('roomMessage', json);
  }
}