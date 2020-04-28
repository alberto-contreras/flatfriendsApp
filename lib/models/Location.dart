class LocationModel {
  String latitude, longitude;

  LocationModel(String lat, String lon){
    this.latitude = lat;
    this.longitude = lon;
  }

  getLatitude(){
    return this.latitude;
  }
  getLongitude(){
    return this.longitude;
  }
}