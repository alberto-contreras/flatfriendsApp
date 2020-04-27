class FlatModel {
  String _id;
  String _name;
  String _description;
  bool _full;
  int _maxPersons;
  List<Location> _location;

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
    Location loc = new Location(lat, lon);
    this._location = new List<Location>();
    this._location.add(loc);
  }

  String getID() => this._id;

  String getName() => this._name;

  String getDescription() => this._description;

  bool getFull() => this._full;

  int getMaxPersons() => this._maxPersons;

  List<Location> getLocation() => this._location;
}

class Location {
  String latitude, longitude;

  Location(String lat, String lon){
    this.latitude = lat;
    this.longitude = lon;
  }
}