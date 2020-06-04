import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/pages/task_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flatfriendsapp/models/UsersInFlatModel.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

import '../models/Task.dart';

SharedData sharedData = SharedData.getInstance();

class FlatService {
  String url = sharedData.getUrlFlat(); //location url for api endpoint

  // Register a new flat and add to the user which registered
  Future<int> registerFlat(FlatModel flatToAdd) async {
    print(flatToAdd);
    print(flatToAdd.getLocation());
    try {
      print('Sending new Flat');
      var response = await http.post(this.url + '/addFlat', body: json.encode({
        'idUser': sharedData.getUser().getIdUser(),
        'name': flatToAdd.getName(),
        'description': flatToAdd.getDescription(),
        'full': flatToAdd.getFull(),
        'maxPersons': flatToAdd.getMaxPersons(),
        'location': {
          'latitude': flatToAdd.getLocation().getLatitude(),
          'longitude': flatToAdd.getLocation().getLongitude()
        },
      }),
          headers: {"accept": "application/json", "content-type": "application/json"});
      if (response.statusCode == 404) {
        print('Already exist a Flat with this name');
        return 1;
      }
      else if (response.statusCode == 201) {
        print('Succesfully created');
        Map flatData = jsonDecode(response.body);
        Map location = flatData['location'];

        flatToAdd.setID(flatData['_id']);
        flatToAdd.setName(flatData['name']);
        flatToAdd.setDescription(flatData['description']);
        flatToAdd.setFull(flatData['full']);
        flatToAdd..setNumPersons(flatData['numPersons']);
        flatToAdd.setMaxPersons(flatData['maxPersons']);
        flatToAdd.setLocation(location['latitude'], location['longitude']);
        //Global Flat added
        print('Okey');
        sharedData.setFlat(flatToAdd);

        //Added to the user the Flat ID that have been created
        sharedData.infoUser.setIdPiso(flatToAdd.getID());
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  // Update the Flat data
  Future<int> updateFlat(FlatModel f) async {
    try {
      print('Updating usuario');
      var response = await http.put(this.url + '/update', body: json.encode({
        '_id': sharedData.getFlat().getID(),
        'name': f.getName(),
        'description': f.getDescription(),
        'numPersons': sharedData.getFlat().getNumPersons(),
        'maxPersons': f.getMaxPersons(),
      }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 400) {
        print('Error updating user');
        return 1;
      }
      else if (response.statusCode == 200) {
        print('Succesfully updated');
        return 0;
      }
      else {
        print('General Error updating User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  // Register a new flat and add to the user which registered
  Future<int> addEventFlat(EventModel eventToAdd) async {

    List jsonList = UsersInFlatModel.encondeToJson(eventToAdd.getUsers());
    print("jsonList: ${jsonList}");


    print('AFTER TESTING NEW THINGS');
    try {
      print('Sending new Event');
      var response = await http.post(this.url + '/event/addEvent', body: json.encode({
        'idPiso': eventToAdd.getIdPiso(),
        'name': eventToAdd.getName(),
        'organizer': eventToAdd.getOrganizer(),
        'description': eventToAdd.getDescription(),
        'date': eventToAdd.getDate(),
        'users': jsonList,
        },
      ),
          headers: {"accept": "application/json", "content-type": "application/json"});
      if (response.statusCode == 500) {
        print('Error');
        return 1;
      }
      else if (response.statusCode == 201) {
        print('Succesfully created');
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> updateEventFlat(EventModel eventToAdd) async {

    List jsonList = UsersInFlatModel.encondeToJson(eventToAdd.getUsers());
    print("jsonList: ${jsonList}");
    try {
      print('Sending new Event');
      var response = await http.put(this.url + '/event/updateEvent', body: json.encode({
        '_id' : eventToAdd.getId(),
        'idPiso': eventToAdd.getIdPiso(),
        'name': eventToAdd.getName(),
        'organizer': eventToAdd.getOrganizer(),
        'description': eventToAdd.getDescription(),
        'date': eventToAdd.getDate(),
        'users': jsonList,
      },
      ),
          headers: {"accept": "application/json", "content-type": "application/json"});
      if (response.statusCode == 400) {
        print('Error');
        return 1;
      }
      else if (response.statusCode == 200) {
        print('Succesfully updated');
        return 0;
      }
      else {
        print('General Error updating User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

// Function to get the flat data
  Future<int> getFlat() async {
    print('Getting the data of a given Flat');
    try {
      final response = await http.get(
          this.url + '/getFlat/' + sharedData.getUser().getIdPiso(),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 404) {
        print('No Flat Found');
        return 1;
      }
      else if (response.statusCode == 200) {
        Map extractFlat = jsonDecode(response.body);
        Map extractLocation = extractFlat['location'];
        print('flatservice: ' + response.body);

        FlatModel flatToAdd = new FlatModel();
        flatToAdd.setID(sharedData.getUser().getIdPiso());
        flatToAdd.setName(extractFlat['name']);
        flatToAdd.setDescription(extractFlat['description']);
        flatToAdd..setNumPersons(extractFlat['numPersons']);
        flatToAdd.setMaxPersons(extractFlat['maxPersons']);
        flatToAdd.setFull(extractFlat['full']);
        flatToAdd.setLocation(
            extractLocation['latitude'], extractLocation['longitude']);
        sharedData.setFlat(flatToAdd);
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> getEventFlat() async {
    print('Searching all the Events of a Flat');
    try {
      final response = await http.get(this.url + '/event/'+sharedData.getUser().getIdPiso(),
          headers: {"accept": "application/json", "content-type": "application/json"});

          //print(response.body);


      if (response.statusCode == 404) {
        print('Not events found');
        return 1;
      }
      else if (response.statusCode == 200) {
        var extractevents = jsonDecode(response.body);
        List events;
        events = extractevents;
        sharedData.eventsFlat.clear();
        for(int i = 0;i<events.length;i++){
          EventModel addEvent = new EventModel();
          addEvent.setId(events[i]['_id']);
          addEvent.setName(events[i]['name']);
          addEvent.setIdPiso(events[i]['idPiso']);
          addEvent.setDescription(events[i]['description']);
          addEvent.setOrganizer(events[i]['organizer']);
          addEvent.setDate(events[i]['date']);
          List users = events[i]['users'];
          for(int j=0;j<users.length;j++) {
            UsersInFlatModel addUser = new UsersInFlatModel();
            addUser.setId(users[j]['id']);
            addUser.setStatus(users[j]['status']);
            addUser.setFirstname(users[j]['firstname']);
            addEvent.setSpecificUser(addUser);
          }
          sharedData.setEvent(addEvent);
        }
        print(''+sharedData.getEvents().elementAt(0).getUsers().length.toString());
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> getUsersFlatForEvent() async {
    print('Searching all the users of a Flat');
    try {
      final response = await http.get(this.url + '/usersFlat/'+sharedData.getUser().getIdPiso(),
          headers: {"accept": "application/json", "content-type": "application/json"});

      print(response.body);


      if (response.statusCode == 404) {
        print('Not users found');
        return 1;
      }
      else if (response.statusCode == 200) {
        var extractusers = jsonDecode(response.body);
        List users;
        users = extractusers;
        sharedData.usersInFlatToCreateEvent.clear(); //In case there is a new user in the flat and we update the list
        for(int i = 0;i<users.length;i++){
          UsersInFlatModel addUserInFlat = new UsersInFlatModel();
          addUserInFlat.setId(users[i]['_id']);
          addUserInFlat.setStatus('0');
          addUserInFlat.setFirstname(users[i]['firstname']);
          sharedData.setUserInFlat(addUserInFlat);
        }
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

//Add a new task to flat tasks
  Future<int> addTaskFlat(TaskModel taskToAdd) async {
    print(taskToAdd);
    try {
      print('Sending new Task');
      var response = await http.post(this.url + '/task/addTask', body: json.encode({
        'idPiso': taskToAdd.getIdPiso(),
        'tittle': taskToAdd.getTittle(),
        'description': taskToAdd.getDescription(),
        'idUser': taskToAdd.getIdUser(),
        'done': taskToAdd.getDone()
      },
      ),
          headers: {"accept": "application/json", "content-type": "application/json"});
      if (response.statusCode == 500) {
        return 1;
      }
      else if (response.statusCode == 201) {
        print('Succesfully created');
        return 0;
      }
      else {
        print('General Error adding Task');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> getTaskFlat() async {
    print('Searching all the Tasks of a Flat');
    try {
      final response = await http.get(this.url + '/task/getFlatTask/'+sharedData.getUser().getIdPiso(),
          headers: {"accept": "application/json", "content-type": "application/json"});

      print('----');
      print(response.body);
      print('----');


      if (response.statusCode == 404) {
        print('No tasks found');
        return 1;
      }
      else if (response.statusCode == 200) {
        var extractTasks = jsonDecode(response.body);
        List tasks;
        tasks = extractTasks;
        sharedData.tasksFlat.clear();
        for(int i = 0;i<tasks.length;i++){
          TaskModel addTask = new TaskModel();
          addTask.setId(tasks[i]['_id']);
          addTask.setTittle(tasks[i]['tittle']);
          addTask.setIdPiso(tasks[i]['idPiso']);
          addTask.setDescription(tasks[i]['description']);
          addTask.setIdUser(tasks[i]['idUser']);
          addTask.setDone(tasks[i]['done']);
          sharedData.setTask(addTask);
          print(sharedData.getTasks().elementAt(0).getTittle());
        }
        return 0;
      }
      else {
        print('General Error adding a task');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> rotateTasks() async {
    print('Rotating the tasks');
    try {
      final response = await http.put(this.url + '/task/rotateTask/' + sharedData.getUser().getIdPiso(),
          headers: {"accept": "application/json", "content-type": "application/json"});

      print(response.body);


      if (response.statusCode == 404) {
        print('No tasks found');
        return 1;
      }
      else if (response.statusCode == 200) {
        var extractTasks = jsonDecode(response.body);
        List tasks;
        tasks = extractTasks;
        sharedData.tasksFlat.clear();
        for(int i = 0;i<tasks.length;i++){
          TaskModel addTask = new TaskModel();
          addTask.setId(tasks[i]['_id']);
          addTask.setTittle(tasks[i]['tittle']);
          addTask.setIdPiso(tasks[i]['idPiso']);
          addTask.setDescription(tasks[i]['description']);
          addTask.setIdUser(tasks[i]['idUser']);
          addTask.setDone(tasks[i]['done']);
          sharedData.setTask(addTask);
          print(addTask.getTittle());
        }
        return 0;
      }
      else {
        print('General Error adding a task');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }
  Future<int> getUsersFlatForTask() async {
    print('Searching all the users of a Flat');
    try {
      final response = await http.get(this.url + '/usersFlat/'+sharedData.getUser().getIdPiso(),
          headers: {"accept": "application/json", "content-type": "application/json"});

      print(response.body);


      if (response.statusCode == 404) {
        print('Not users found');
        return 1;
      }
      else if (response.statusCode == 200) {
        var extractusers = jsonDecode(response.body);
        List users;
        users = extractusers;
        sharedData.usersInFlat.clear(); //In case there is a new user in the flat and we update the list
        for(int i = 0;i<users.length;i++){
          List<String> userInFlat = [users[i]['_id'],users[i]['firstname']];
          sharedData.setUserInUsersInFlat(userInFlat);
          print(sharedData.getUsersInFlatForTask());
        }
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> updateTask(TaskModel task) async {
    try {
      print('Updating Task');
      var response = await http.put(this.url + '/task/updateTask', body: json.encode({
        '_id': task.getId(),
        'idPiso': task.getIdPiso(),
        'tittle': task.getTittle(),
        'description': task.getDescription(),
        'idUser': task.getIdUser(),
        'done': task.getDone()
      },
      ),
          headers: {"accept": "application/json", "content-type": "application/json"});
      if (response.statusCode == 500) {
        return 1;
      }
      else if (response.statusCode == 200) {
        print('Succesfully updated');
        return 0;
      }
      else {
        print('General Error adding Task');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> addTenant(String tenantId, String flatId) async {
    try {
      print('Adding tenant to the flat');
      var response = await http.put(this.url + '/addTenant/', body: json.encode({
        ///TAMBIEN EL TOKEN!
        'tenantId' : tenantId,
        'flatId': flatId
      }),
          headers: {"accept": "application/json", "content-type": "application/json" });
      if(response.statusCode == 409){
        print('Error flat is full.');
        return 2;
      }
      if(response.statusCode == 404){
        print('Error updating user or flat. Not found.');
        return 1;
      }
      else if(response.statusCode == 200){
        print('Tenant succesfully added.');
        return 0;
      }
      else {
        print('General Error updating User');
        return 1;
      }
    }
    catch(error){
      print(error);
      return 1;
    }
  }

  Future<int> removeTenant(String tenantId, String flatId) async {
    try {
      print('Adding tenant to the flat');
      var response = await http.put(this.url + '/removeTenant/', body: json.encode({
        ///TAMBIEN EL TOKEN!
        'tenantId' : tenantId,
        'flatId': flatId
      }),
          headers: {"accept": "application/json", "content-type": "application/json" });
      if(response.statusCode == 404){
        print('Error updating user or flat. Not found.');
        return 1;
      }
      else if(response.statusCode == 200){
        print('Tenant succesfully removed from flat.');
        return 0;
      }
      else {
        print('General Error updating User');
        return 1;
      }
    }
    catch(error){
      print(error);
      return 1;
    }
  }

  // Function to get a more detailed data from a flat
  Future<int> getTenantsFlat() async {
    print('Searching all the Tenants of a Flat');
    try {
      final response = await http.get(this.url + '/allUsersDataFlat/'+sharedData.getUser().getIdPiso(),
          headers: {"accept": "application/json", "content-type": "application/json"});

      if (response.statusCode == 404) {
        print('Not tenants found');
        return 1;
      }
      else if (response.statusCode == 200) {
        List extractTenants = jsonDecode(response.body);
        sharedData.getTenants().clear();
        extractTenants.forEach((tenant) {
          if (sharedData.getUser().getEmail() != tenant['email']) {
            UserModel tenantToAdd = new UserModel();
            tenantToAdd.setFirstname(tenant['firstname']);
            tenantToAdd.setLastname(tenant['lastname']);
            tenantToAdd.setPhoneNumber(tenant['phoneNumber']);
            tenantToAdd.setEmail(tenant['email']);
            tenantToAdd.setUrlAvatar(tenant['urlAvatar']);
            sharedData.setTenant(tenantToAdd);
          }
        });
        return 0;
      }
      else {
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  Future<int> deleteTask(TaskModel task) async {
    try {
      print('Del Task');
      var response = await http.delete(this.url + '/task/delete/' + task.getId(),
          headers: {"accept": "application/json", "content-type": "application/json"});
      if (response.statusCode == 500) {
        return 1;
      }
      else if (response.statusCode == 200) {
        print('Succesfully updated');
        return 0;
      }
      else {
        print('General Error adding Task');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }
}