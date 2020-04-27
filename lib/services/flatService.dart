import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Flat.dart';
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
        '_id': sharedData.getUser().getIdUser(),
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
        flatToAdd.setID(flatData['_id']);
        flatToAdd.setName(flatData['name']);
        flatToAdd.setDescription(flatData['description']);
        flatToAdd.setFull(flatData['full']);
        flatToAdd.setMaxPersons(flatData['maxPersonas']);
        flatToAdd.setLocation(flatData['location[0].latitude'], flatData['location[0].longitude']);
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