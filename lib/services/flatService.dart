import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/flat.dart';
import 'package:flatfriendsapp/models/user.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


class FlatService {
  String url = 'http://10.0.2.2:3702/flat/'; //location url for api endpoint
  SharedData sharedData = SharedData.getInstance();

  Future<int> registerFlat(FlatModel flatToAdd) async {
    try {
      print('Sending new Flat');
      var response = await http.post(this.url + 'addFlat/', body: json.encode({
        '_id': sharedData.getUser().getIdUser(),
        'name': flatToAdd.getName(),
        'description': flatToAdd.getDescription(),
      }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 404) {
        print('Already exist a Flat with this name');
        return 1;
      }
      else if (response.statusCode == 201) {
        print('Succesfully created');
        Map flatData = jsonDecode(response.body);
        flatToAdd.setID(flatData['_id']);
        flatToAdd.setName(flatData['name']);
        flatToAdd.setDescription(flatData['description']);
        //Global Flat added
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
}