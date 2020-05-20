import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/chatService.dart';

class SharedData {

  static  SharedData instance;

  UserModel infoUser;
  FlatModel infoFlat;
  String token;
 // String apiUrl = 'http://147.83.7.155:3702';
  String apiUrl = 'http://localhost:3702';
  String urlUser;
  String urlFlat;
  bool chatRunning = false;
  List<ChatMessageModel> messages = new List<ChatMessageModel>();
  List<EventModel> eventsFlat = new List<EventModel>();
  ChatService chatService = new ChatService();
  EventModel eventDetails = new EventModel();


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

  setEvent(EventModel event){
    this.eventsFlat.add(event);
  }

  setEventDetails(EventModel event){
    this.eventDetails = event;
  }

  List<ChatMessageModel> getMessages() => this.messages;

  List<EventModel> getEvents() => this.eventsFlat;

  UserModel getUser() => this.infoUser;

  FlatModel getFlat() => this.infoFlat;

  String getUrlUser() => this.urlUser;

  String getUrlFlat() => this.urlFlat;

  EventModel getEventDetails() => this.eventDetails;

}