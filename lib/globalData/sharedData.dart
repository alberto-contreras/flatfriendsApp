import 'dart:async';
import 'dart:io';

import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/models/UsersInFlatModel.dart';
import 'package:flatfriendsapp/pages/available_flats_page.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flatfriendsapp/models/UsersInDebtModel.dart';
import 'package:flatfriendsapp/models/Debt.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SharedData {

  static SharedData instance;

  UserModel infoUser;
  FlatModel infoFlat;
  String token;

  String apiUrl = 'http://10.0.2.2:3702';
//  String apiUrl = 'http://147.83.7.155:3702';
//  String apiUrl = 'http://localhost:3702';


  String urlUser;
  String urlFlat;
  String idChatRoom;
  bool chatRunning = false;
  bool chatRoomExists = false;
  bool socketStatusOn = false;

  List<ChatMessageModel> messages = new List<ChatMessageModel>();
  List<EventModel> eventsFlat = new List<EventModel>();
  List<UserModel> tenantsFlat = new List<UserModel>();
  List<TaskModel> tasksFlat = new List<TaskModel>();
  List<DebtModel> debtFlat = new List<DebtModel>();

  ChatService chatService = new ChatService();

  final chatStream = new StreamController<List<ChatMessageModel>>.broadcast();
//  final chatStream = new StreamController<List<ChatMessageModel>>();


  Map usersInFlat = new Map();
  EventModel eventDetails = new EventModel();
  List<UsersInFlatModel> usersInFlatToCreateEvent = new List<UsersInFlatModel>();

  DebtModel debtDetails = new DebtModel();
  List<UsersInDebtModel> usersInFlatToShareDebts = new List<UsersInDebtModel>();

  List<FlatModel> availableFlats = new List<FlatModel>();

  Position currentPosition = new Position();

  StreamSubscription<Position> _positionStreamSubscription;


  SharedData() {
    this.urlUser = this.apiUrl + '/user';
    this.urlFlat = this.apiUrl + '/flat';
  }

  static SharedData getInstance() {
    if (instance == null) {
      instance = SharedData();
    }
    return instance;
  }

  setUser(UserModel a) {
    this.infoUser = a;
    print(infoUser.getIdUser());
  }

  setFlat(FlatModel a) {
    this.infoFlat = a;
  }

  setChatRoomStatus(bool value){
    this.chatRoomExists = value;
  }

  setMessage(ChatMessageModel message) async {
    this.messages.insert(0, message);
    await this.chatStream.sink.add(messages);
  }

  setEvent(EventModel event) {
    this.eventsFlat.add(event);
  }

  setDebt(DebtModel debt){
    this.debtFlat.add(debt);
  }

  setTenant(UserModel value) {
    this.tenantsFlat.add(value);
  }

  setTask(TaskModel task) {
    this.tasksFlat.add(task);
  }

  setUserInUsersInFlat(List<String> userInFlat) {
    this.usersInFlat[userInFlat[0]] = userInFlat[1];
    print(this.usersInFlat);
  }

  setUserInFlat(UsersInFlatModel user) {
    this.usersInFlatToCreateEvent.add(user);
  }

  setUserToShareDebt(UsersInDebtModel user){
    this.usersInFlatToShareDebts.add(user);
  }

  setEventDetails(EventModel event) {
    this.eventDetails = event;
  }


  setAvailableFlats(List<FlatModel> availableFlats) {
    this.availableFlats = availableFlats;
  }

  setCurrentPosition(Position position) {
    this.currentPosition = position;
  }

  setIdChatRoom(String value){
    this.idChatRoom = value;
  }

  setSocketStatusOn(bool value){
    this.socketStatusOn = value;
  }

  Position getCurrentPosition() => this.currentPosition;

  List<FlatModel> getAvailableFlats() => this.availableFlats;


  setDebtDetails(DebtModel debt) {
    this.debtDetails = debt;
  }


  List<ChatMessageModel> getMessages() => this.messages;

  List<EventModel> getEvents() => this.eventsFlat;

  List<DebtModel> getDebts() => this.debtFlat;

  List<UserModel> getTenants() => this.tenantsFlat;

  List<TaskModel> getTasks() => this.tasksFlat;

  List<UsersInFlatModel> getUsersInFlatForEvent() =>
      this.usersInFlatToCreateEvent;

  List<UsersInDebtModel> getUsersInFlatToShareDebts() => this.usersInFlatToShareDebts;

  UserModel getUser() => this.infoUser;

  FlatModel getFlat() => this.infoFlat;

  String getUrlUser() => this.urlUser;

  String getUrlFlat() => this.urlFlat;

  bool getChatRoomStatus() => this.chatRoomExists;

  Map getUsersInFlatForTask() => this.usersInFlat;

  EventModel getEventDetails() => this.eventDetails;

  String getIdChatRoom() => this.idChatRoom;

  bool getSocketStatusOn() => this.socketStatusOn;


  clearFlat() {
    this.infoUser.setIdPiso(null);
    this.infoFlat = null;
    this.chatRunning = false;
    this.eventsFlat.clear();
    this.tenantsFlat.clear();
    this.tasksFlat.clear();
//    this.chatService.stopChatService();
    this.usersInFlat.clear();
    this.usersInFlatToCreateEvent.clear();
  }

  // Clear the the content of this single tone
  clear() async {
//    instance = new SharedData();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.remove('password');
    prefs.remove('googleAuth');
    this.infoUser = null;
    this.infoFlat = null;
    this.chatRunning = false;
    this.messages.clear();
    this.eventsFlat.clear();
    this.tenantsFlat.clear();
    this.tasksFlat.clear();
//    this.chatService.stopChatService();
    this.usersInFlat.clear();
    this.usersInFlatToCreateEvent.clear();
  }

  DebtModel getDebtDetails() => this.debtDetails;

}