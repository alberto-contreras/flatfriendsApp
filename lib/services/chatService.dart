import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/models/Message.dart';
import 'package:flatfriendsapp/pages/chat_page.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

SharedData sharedData = SharedData.getInstance();
Chat pinchewey = new Chat();

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
    print('Envíamos un mensaje');
    socket.emit('roomMessage', json);
  }
}