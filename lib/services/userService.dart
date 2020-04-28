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
        return 1;
      }
    }
    catch(error){
      print(error);
      return 1;
    }
  }

  // Make loging in of an user
  Future<Object> logUser(UserModel userToLog) async {
    try {
      var response = await http.post(this.url + '/login', body: json.encode({
        'email' : userToLog.getEmail(),
        'password' : userToLog.getPassword(),
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
        Map userData = jsonDecode(response.body);
        userToLog.setIdUser(userData['_id']);
        userToLog.setFirstname(userData['firstname']);
        userToLog.setLastname(userData['lastname']);
        userToLog.setEmail(userData['email']);
        userToLog.setPhoneNumber(userData['phoneNumber']);
        userToLog.setIdPiso(userData['idPiso']);
        userToLog.setPassword(userData['password']);
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
  Future<int> deleteUser(String email) async {
    try {
      //make the request
      print('Erasing user');
      var response = await http.delete(this.url + '/del/' + email);
      if(response.statusCode == 404)
      {
        print('Error erasing user');
        return 1;
      }
      else if(response.statusCode == 200){
        print('Succesfully created');
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
        ///TAMBIEN EL TOKEN!
        '_id' : u.getIdUser(),
        'firstname': u.getFirstname(),
        'lastname' : u.getLastname(),
        'email' : u.getEmail(),
        'phoneNumber':u.getPhoneNumber(),
        'password' : u.getPassword(),
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

}

