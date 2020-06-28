import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/pages/chat_page.dart';
import 'package:flutter/cupertino.dart';
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
    if (sharedData.getSocketStatusOn() == false){
      socket.connect();
      onMessage();
      sharedData.setSocketStatusOn(true);
      print('Estableciendo socket!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    }

    if (sharedData.getChatRoomStatus() == false){
      sharedData.setChatRoomStatus(true);
      sharedData.setIdChatRoom(flatId);
      socket.emit('joinToTheRoom', flatId);
      print('SE ACABA DE DEFINIR UNA SALAAAA !!!!!!!!!!!!!!!!!!!!!!!!!!!');
    }
  }

  stopChatService(){
    socket.disconnect();
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