import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

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


  // Register a new flat and add to the user which registered
  Future<int> addEventFlat(EventModel eventToAdd) async {
    print(eventToAdd);
    try {
      print('Sending new Event');
      var response = await http.post(this.url + '/event/addEvent', body: json.encode({
        'idPiso': eventToAdd.getIdPiso(),
        'name': eventToAdd.getName(),
        'organizer': eventToAdd.getOrganizer(),
        'description': eventToAdd.getDescription(),
        'date': eventToAdd.getDate(),
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
        print('General Error adding User');
        return 1;
      }
    }
    catch (error) {
      print(error);
      return 1;
    }
  }

  // I que s'executi
  // quan es fa login i l'usuari ja té idPiso
  // quan un usuari inserta el codi d'un pis al que es vol unir

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
        flatToAdd.setMaxPersons(extractFlat['maxPersons']);
        flatToAdd.setFull(extractFlat['full']);
        flatToAdd.setLocation(
            extractLocation['longitude'], extractLocation['latitude']);
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

          print(response.body);


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
          addEvent.setName(events[i]['name']);
          addEvent.setIdPiso(events[i]['idPiso']);
          addEvent.setDescription(events[i]['description']);
          addEvent.setOrganizer(events[i]['organizer']);
          addEvent.setDate(events[i]['date']);
          sharedData.setEvent(addEvent);
          print(addEvent.getName());
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


//Add a new task to flat tasks
//  Future<int> addTaskFlat(EventModel taskToAdd) async {
//    print(taskToAdd);
//    try {
//      print('Sending new Task');
//      var response = await http.post(this.url + '/task/addTask', body: json.encode({
//        'idPiso': taskToAdd.getIdPiso(),
//        'tittle': taskToAdd.getTittle(),
//        'description': taskToAdd.getDescription(),
//        'idUser': taskToAdd.getIdUser(),
//      },
//      ),
//          headers: {"accept": "application/json", "content-type": "application/json"});
//      if (response.statusCode == 500) {
//        return 1;
//      }
//      else if (response.statusCode == 201) {
//        print('Succesfully created');
//        return 0;
//      }
//      else {
//        print('General Error adding Task');
//        return 1;
//      }
//    }
//    catch (error) {
//      print(error);
//      return 1;
//    }
//  }

//  Future<int> getEventFlat() async {
//    print('Searching all the Tasks of a Flat');
//    try {
//      final response = await http.get(this.url + '/task/getFlatTask'+sharedData.getUser().getIdPiso(),
//          headers: {"accept": "application/json", "content-type": "application/json"});
//
//      print(response.body);
//
//
//      if (response.statusCode == 404) {
//        print('No tasks found');
//        return 1;
//      }
//      else if (response.statusCode == 200) {
//        var extractTasks = jsonDecode(response.body);
//        List events;
//        tasks = extractTasks;
//        sharedData.tasksFlat.clear();
//        for(int i = 0;i<tasks.length;i++){
//          TaskModel addTask = new TaskModel();
//          addTask.setTittle(tasks[i]['tittle']);
//          addTask.setIdPiso(tasks[i]['idPiso']);
//          addTask.setDescription(tasks[i]['description']);
//          addTask.setIdUser(tasks[i]['idUser']);
//          sharedData.setTask(addTask);
//          print(addTask.getTittle());
//        }
//        return 0;
//      }
//      else {
//        print('General Error adding a task');
//        return 1;
//      }
//    }
//    catch (error) {
//      print(error);
//      return 1;
//    }
//  }

}
