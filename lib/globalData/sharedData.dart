import 'dart:async';

import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/models/UsersInFlatModel.dart';
import 'package:flatfriendsapp/models/UsersInDebtModel.dart';
import 'package:flatfriendsapp/models/Debt.dart';

import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flutter/cupertino.dart';

class SharedData {

  static SharedData instance;

  UserModel infoUser;
  FlatModel infoFlat;
  String token;

 String apiUrl = 'http://10.0.2.2:3702';
 // String apiUrl = 'http://147.83.7.155:3702';
  //String apiUrl = 'http://localhost:3702';

  String urlUser;
  String urlFlat;
  String urlUserAvatar; // Provisional! Lo suyo sería meterlo como atributo no requerido de user (No lo implemento para no dificultar más aún en el merge)
  bool chatRunning = false;

  List<ChatMessageModel> messages = new List<ChatMessageModel>();
  List<EventModel> eventsFlat = new List<EventModel>();
  List<UserModel> tenantsFlat = new List<UserModel>();
  List<TaskModel> tasksFlat = new List<TaskModel>();
  List<DebtModel> debtFlat = new List<DebtModel>();

  ChatService chatService = new ChatService();
  final chatStream = new StreamController<List<ChatMessageModel>>.broadcast();

  Map usersInFlat = new Map();

  EventModel eventDetails = new EventModel();
  List<UsersInFlatModel> usersInFlatToCreateEvent = new List<UsersInFlatModel>();

  DebtModel debtDetails = new DebtModel();
  List<UsersInDebtModel> usersInFlatToShareDebts = new List<UsersInDebtModel>();


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

  setUserUrlAvatar(String value) {
    this.urlUserAvatar = value;
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

  String getUrlUserAvatar() => this.urlUserAvatar;

  Map getUsersInFlatForTask() => this.usersInFlat;

  EventModel getEventDetails() => this.eventDetails;

  DebtModel getDebtDetails() => this.debtDetails;

}