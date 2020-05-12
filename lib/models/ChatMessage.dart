import 'package:flatfriendsapp/models/Location.dart';

class ChatModel {
  String idFlat;
  List<Message> messages;


  ChatModel();

  setIdFlat(String idF){
    this.idFlat = idF;
  }

  setMessage(String uName, String msg){

  }



}

class Message {
  String userName;
  String message;
  String dateTime;

  Message(String uName, String msg, String dateT){
    this.userName = uName;
    this.message = msg;
    this. dateTime = dateT;
  }

}