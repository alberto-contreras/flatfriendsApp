import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/chatService.dart';

class SharedData {

  static  SharedData instance;

  UserModel infoUser;
  FlatModel infoFlat;
  String token;
//  String apiUrl = 'http://localhost:3702';
  String apiUrl = 'http://10.0.2.2:3702';
  String urlUser;
  String urlFlat;
  bool chatRunning = false;
  List<ChatMessageModel> messages = new List<ChatMessageModel>();
  ChatService chatService = new ChatService();


  SharedData() {
    this.urlUser = this.apiUrl + '/user';
    this.urlFlat = this.apiUrl + '/flat';

  }

  static SharedData getInstance()
  {
    if(instance == null)
    {
      instance = SharedData();
    }
    return instance;
  }

  setUser(UserModel a)
  {
    this.infoUser = a;
    print(infoUser.getIdUser());
  }

  setFlat(FlatModel a)
  {
    this.infoFlat = a;
  }

  setMessage(ChatMessageModel message) {
    this.messages.add(message);
  }

  List<ChatMessageModel> getMessages() => this.messages;

  UserModel getUser() => this.infoUser;

  FlatModel getFlat() => this.infoFlat;

  String getUrlUser() => this.urlUser;

  String getUrlFlat() => this.urlFlat;

  // String getChatServerUrl() => this.chatServerUrl;
}