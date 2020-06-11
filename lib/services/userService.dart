import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

SharedData sharedData = SharedData.getInstance();

class UserService {
  String url = sharedData.getUrlUser(); //location url for api endpoint

  // Register a new user
  Future<int> registerUser(UserModel userToAdd) async {
    try {
      print('Sending new User');
      var response = await http.post(this.url + '/addUser',body: json.encode({
        'firstname': userToAdd.getFirstname(),
        'lastname' : userToAdd.getLastname(),
        'email' : userToAdd.getEmail(),
        'idPiso': null,
        'password' : userToAdd.getPassword(),
        'googleAuth' : userToAdd.getGoogleAuth(),
        'allTasks': '0',
      }),
        headers: {"accept": "application/json", "content-type": "application/json" });
      if(response.statusCode == 409)
        {
          print('Already exist a User with this email');
          return 1;
        }
      else if(response.statusCode == 201){
        print('Succesfully created');
        return 0;
      }
      else {
        print('General Error adding User');
        return 2;
      }
    }
    catch(error){
      print(error);
      return 2;
    }
  }

  // Make loging in of an user
  Future<Object> logUser(UserModel userToLog) async {
    try {
      var response = await http.post(this.url + '/login', body: json.encode({
        'email' : userToLog.getEmail(),
        'password' : userToLog.getPassword(),
        'googleAuth': userToLog.getGoogleAuth()
      }),
          headers: {"accept": "application/json", "content-type": "application/json" });
      print(response.statusCode);
      if(response.statusCode == 400)
      {
        print('Error');
        return 1;
      }
      else {
        print('Succesfully logged');
        print(response.body);
        Map userData = jsonDecode(response.body);
        userToLog.setIdUser(userData['_id']);
        userToLog.setFirstname(userData['firstname']);
        userToLog.setLastname(userData['lastname']);
        userToLog.setEmail(userData['email']);
        userToLog.setPhoneNumber(userData['phoneNumber']);
        userToLog.setIdPiso(userData['idPiso']);
        userToLog.setPassword(userData['password']);
        userToLog.setUrlAvatar(userData['urlAvatar']);
        userToLog.setAllTasks(userData['allTasks']);

        sharedData.setUser(userToLog);
        //sharedData.setToken(tokensiko);
        return 0;
      }
    }
    catch(error){
      print(error);
      return 1;
    }
  }

  // Delete an user account
  Future<int> deleteUser() async {
    try {
      //make the request
      print('Erasing user');
      var response = await http.delete(this.url + '/' + sharedData.getUser().getIdUser());
      if(response.statusCode == 404)
      {
        print('Error erasing user');
        return 1;
      }
      else if(response.statusCode == 200){
        print('Succesfully deleted');
        return 0;
      }
      else {
        print('General Error erasing User');
        return 1;
      }
    }
    catch(error){
      print(error);
      return 1;
    }
  }

  // Update the user data
  Future<int> updateUser(UserModel u) async {
    try {
      print('Updating usuario');
      var response = await http.put(this.url + '/update', body: json.encode({
        '_id' : sharedData.getUser().getIdUser(),
        'email' : u.getEmail(),
        'phoneNumber':u.getPhoneNumber(),
        'urlAvatar': u.getUrlAvatar(),
        'password' : u.getPassword(),
        'idPiso' : u.getIdPiso(),
        'allTasks': u.getAllTasks()
      }),
          headers: {"accept": "application/json", "content-type": "application/json" });
      if(response.statusCode == 400)
      {
        print('Error updating user');
        return 1;
      }
      else if(response.statusCode == 200){
        print('Succesfully updated');
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
  Future<int> updateUserAllTasks(UserModel u) async {
    try {
      print('Updating usuario');
      var response = await http.put(this.url + '/tasksupdate', body: json.encode({
        '_id' : u.getIdUser(),
        'allTasks': u.getAllTasks()
      }),
          headers: {"accept": "application/json", "content-type": "application/json" });
      if(response.statusCode == 400) {
        print('Error updating user');
        return 1;
      }
      else if(response.statusCode == 200) {
        print('Succesfully updated');
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
  Future<int> getUserByEmail(String emailUser) async {
    try {
      var response = await http.get(this.url + '/getUserByEmail/'+emailUser);
      print(response.statusCode);
      if(response.statusCode == 400)
      {
        print('Error');
        return 1;
      }
      else {
        print('Succesfully arrived');
        print(response.body);
        Map userData = jsonDecode(response.body);
        sharedData.getUser().setIdUser(userData['_id']);
        sharedData.getUser().setPhoneNumber(userData['phoneNumber']);
        sharedData.getUser().setIdPiso(userData['idPiso']);

        //sharedData.setToken(tokensiko);
        return 0;
      }
    }
    catch(error){
      print(error);
      return 1;
    }
  }





}

