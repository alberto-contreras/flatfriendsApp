import 'dart:io';

import 'package:flatfriendsapp/models/user.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


class UserService {
  String location; //location name for the UI
  String time; //time in that location
  String flag; //url to an asset flag icon
  String url = 'http://localhost:3702/user/';//location url for api endpoint
  bool isDaytime; //True or False if daytime or not

  Future<int> registerUser(UserModel userToAdd) async {

    try {
      //make the request

      print('Se envia registro');
      var response = await http.post(this.url+'addUser/',body: json.encode({
        'firstname': userToAdd.getFirstname(),
        'lastname' : userToAdd.getLastname(),
        'email' : userToAdd.getEmail(),
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
    }
  }

  Future<Object> logUser(UserModel userToLog) async {

    try {
      //make the request
      UserModel u = new UserModel();
      var response = await http.post(this.url+'login/',body: json.encode({
        'email' : userToLog.getEmail(),
        'password' : userToLog.getPassword(),
      }),
          headers: {"accept": "application/json", "content-type": "application/json" });
      if(response.statusCode == 400)
      {
        print('Error');
        return 1;
      }
      else {
        print('Sccesfully logged');
        Map userData = jsonDecode(response.body);
        UserModel u = new UserModel();
        //Set SINGLETONE
        u.setFirstname(userData['firstname']);
        u.setLastname(userData['lastname']);
        u.setEmail(userData['email']);
        u.setPhoneNumber(userData['phoneNumber']);
        //u.setIdPiso(userData['idPiso']);
        u.setPassword(userData['password']);
        return 0;
      }
    }
    catch(error){
      print(error);
    }
  }
}

