import 'dart:async';

import 'package:flatfriendsapp/models/ChatMessage.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/models/UsersInFlatModel.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool chatRunning = false;
  List<ChatMessageModel> messages = new List<ChatMessageModel>();
  List<EventModel> eventsFlat = new List<EventModel>();
  List<UserModel> tenantsFlat = new List<UserModel>();
  List<TaskModel> tasksFlat = new List<TaskModel>();
  ChatService chatService = new ChatService();
  final chatStream = new StreamController<List<ChatMessageModel>>.broadcast();
  Map usersInFlat = new Map();
  EventModel eventDetails = new EventModel();
  List<UsersInFlatModel> usersInFlatToCreateEvent = new List<
      UsersInFlatModel>();


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

  setEventDetails(EventModel event) {
    this.eventDetails = event;
  }

  List<ChatMessageModel> getMessages() => this.messages;

  List<EventModel> getEvents() => this.eventsFlat;

  List<UserModel> getTenants() => this.tenantsFlat;

  List<TaskModel> getTasks() => this.tasksFlat;

  List<UsersInFlatModel> getUsersInFlatForEvent() =>
      this.usersInFlatToCreateEvent;

  UserModel getUser() => this.infoUser;

  FlatModel getFlat() => this.infoFlat;

  String getUrlUser() => this.urlUser;

  String getUrlFlat() => this.urlFlat;

  Map getUsersInFlatForTask() => this.usersInFlat;

  EventModel getEventDetails() => this.eventDetails;

  clearFlat() {
    this.infoUser.setIdPiso(null);
    this.infoFlat = null;
    this.chatRunning = false;
    this.eventsFlat.clear();
    this.tenantsFlat.clear();
    this.tasksFlat.clear();
    this.chatService.stopChatService();
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
    this.chatService.stopChatService();
    this.usersInFlat.clear();
    this.usersInFlatToCreateEvent.clear();
  }
}