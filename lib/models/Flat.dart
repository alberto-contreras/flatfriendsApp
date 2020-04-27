

import 'package:flatfriendsapp/models/Location.dart';

class FlatModel {
  String _id;
  String _name;
  String _description;
  bool _full;
  int _maxPersons;
  LocationModel _location;

  FlatModel();

  setID(String id)
  {
    this._id = id;
  }

  setName(String name)
  {
    this._name = name;
  }

  setDescription(String description)
  {
    this._description = description;
  }

  setFull(bool f){
    this._full = f;
  }

  setMaxPersons(int mp){
    this._maxPersons = mp;
  }

  setLocation(String lat, String lon){
    LocationModel loc = new LocationModel(lat, lon);
    this._location = loc;
  }

  String getID() => this._id;

  String getName() => this._name;

  String getDescription() => this._description;

  bool getFull() => this._full;

  int getMaxPersons() => this._maxPersons;

  LocationModel getLocation() => this._location;
}

