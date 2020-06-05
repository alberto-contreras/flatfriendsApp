import 'dart:async';
import 'dart:math';

import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

SharedData sharedData = SharedData.getInstance();

class AvailableFlats extends StatefulWidget {
  @override
  _AvailableFlatsState createState() => _AvailableFlatsState();
}

class _AvailableFlatsState extends State<AvailableFlats> {

  TextEditingController rangeTextBox = new TextEditingController();

  UserService userService = new UserService();
  FlatService flatService = new FlatService();

  List<FlatModel> availableFlats = sharedData.getAvailableFlats();
  List<FlatModel> matchedFlats = new List<FlatModel>();

  MapController mapController = MapController();
  List<Marker> markers = [];

  FlatModel selectedFlat = new FlatModel();

  bool viewMap = true;

  int maxDistance = 0;
  int minDistance = 41000;
  int range;

  StreamSubscription<Position> _positionStreamSubscription;
  Position _position = sharedData.getCurrentPosition();

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best);
      final Stream<Position> positionStream =
      Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen(
              (Position position) => setState(() => _position = position));
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _toggleListening();

    availableFlats.sort((a,b) => calculateDistance(_position.latitude, _position.longitude, double.parse(a.getLocation().latitude), double.parse(a.getLocation().longitude))
        .compareTo(calculateDistance(_position.latitude, _position.longitude, double.parse(b.getLocation().latitude), double.parse(b.getLocation().longitude))));

    minDistance = calculateDistance(_position.latitude, _position.longitude, double.parse(availableFlats[0].getLocation().latitude), double.parse(availableFlats[0].getLocation().longitude)).round();
    maxDistance = calculateDistance(_position.latitude, _position.longitude, double.parse(availableFlats[availableFlats.length - 1].getLocation().latitude), double.parse(availableFlats[availableFlats.length - 1].getLocation().longitude)).round();
    range = maxDistance;
  }

  @override
  Widget build(BuildContext context) {

    matchedFlats = [];
    for (int i = 0; i < availableFlats.length; i++) {
      if (range < calculateDistance(_position.latitude, _position.longitude, double.parse(availableFlats[i].getLocation().latitude), double.parse(availableFlats[i].getLocation().longitude)).round()) {
        i = availableFlats.length;
      } else {
        matchedFlats.add(availableFlats[i]);
      }
    }

    markers = [];
    matchedFlats.forEach((flat) {
      markers.add(Marker(
          height: 200,
          width: 300,
          point: new LatLng(double.parse(
              flat
                  .getLocation()
                  .getLatitude()), double.parse(
              flat
                  .getLocation()
                  .getLongitude())),
          builder: (ctx) =>
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFlat = flat;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: selectedFlat == flat ? 1.0 : 0.0,
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: <Widget>[
                                flatCard(flat),
                                Icon(Icons.location_on, color: Colors.black54,
                                  size: 45.0,),
                              ],
                            )
                        ),
                      ),
                      Opacity(
                        child: Container(
                          alignment: Alignment.center,
                          child: Icon(Icons.location_on, color: Colors.black54,
                            size: 45.0,),
                        ),
                        opacity: selectedFlat == flat ? 0.0 : 1.0,
                      )
                    ],
                  )
              )
      )
      );
    });

    markers.add(Marker(
        point: LatLng(_position.latitude,_position.longitude),
        builder: (context) => Icon(Icons.my_location, color: Colors.blueAccent, size: 25)
    ));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Pisos Disponibles', style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (viewMap) Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: new LatLng(_position.latitude,_position.longitude),
                    zoom: 10.0,
                    interactive: true,
                  ),
                  layers: [
                    new TileLayerOptions(
                      urlTemplate: "https://api.mapbox.com/styles/v1/grupo1ea/ckamlz1jw4x661ilkwv5djupf/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ3J1cG8xZWEiLCJhIjoiY2thbWR1aWYyMGo4YTJ5cXdzMnM1ZHV1cCJ9.hFVy8x411MXAGB9AAVZUqQ",
                      additionalOptions: {
                        'accessToken': 'pk.eyJ1IjoiZ3J1cG8xZWEiLCJhIjoiY2thbWR1aWYyMGo4YTJ5cXdzMnM1ZHV1cCJ9.hFVy8x411MXAGB9AAVZUqQ',
                        'id': 'mapbox.streets',
                      },
                    ),
                    MarkerLayerOptions(markers: markers),
                  ],
                  mapController: mapController,
                ),
              ),
              if (!viewMap) Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical:1.0, horizontal: 4.0),
                  itemCount: matchedFlats.length,
                  itemBuilder: (context,index){ //This function will make a widget tree of the one we choose

                    return flatCard(matchedFlats.elementAt(index));
                  },
                ),
              ),
              Container(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('¿Que tan lejos vivirías?'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: 80,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => setState(() {
                                    int input = int.parse(value);
                                    if (input < minDistance) {
                                      range = minDistance;
                                    } else if (input > maxDistance) {
                                      range = maxDistance;
                                    } else {
                                      range = input;
                                    }
                                  }),
                                  controller: rangeTextBox,
                                  decoration: InputDecoration(
                                    hintText: range.toString(),
                                  ),
                                ),
                              ),
                              Text('Km')
                            ],
                          ),
                          Slider(
                            divisions: maxDistance - minDistance,
                            max: maxDistance.toDouble(),
                            min: minDistance.toDouble(),
                            label: (range.toString() + ' Km'),
                            value: range.toDouble(),
                            onChanged: (value) => setState(() {
                              range = value.round();
                              rangeTextBox.text = range.toString();
                            }),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              color: viewMap? Colors.black12 : Colors.white,
                              child: Text('Mapa'),
                              onPressed: () => setState(() {viewMap = true;}),
                            ),
                            FlatButton(
                              color: !viewMap? Colors.black12 : Colors.white,
                              child: Text('Lista'),
                              onPressed: () => setState(() {viewMap = false;}),
                            ),
                          ],
                        ),)
                    ],
                  )
              )

            ],
          ),
        )
    );
  }

  Widget geiInButton (String id) {
    return IconButton(icon: Icon(Icons.input, size: 20,), onPressed: () async {
      sharedData.getUser().setIdPiso(id);
      int res = await userService.updateUser(sharedData.getUser());
      if (res == 0) {
        await flatService.getFlat();
        await flatService.getTenantsFlat();
        await sharedData.chatService.initChatService(sharedData.getUser().getIdPiso());
        sharedData.chatService.onMessage();
        sharedData.chatRunning = true;
        Navigator.of(context).pop();
      }
      else {
        Navigator.of(context).pop();
      }
    },);
  }

  Widget flatCard(FlatModel flat) {
    return Card(
      margin: const EdgeInsets.only(
        top: 16.0,
        bottom: 1.0,
        left: 24.0,
        right: 24.0,
      ),
      child: ListTile(//Link on press function
        title:  Row(children: <Widget>[
          Expanded(
            child: Text(flat.getName(), style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Text('(a ' + calculateDistance(_position.latitude, _position.longitude, double.parse(flat.getLocation().latitude), double.parse(flat.getLocation().longitude)).round().toString() + ' Km)'),
        ],),
        subtitle: Text(flat.getDescription()),
        trailing: geiInButton(flat.getID()),
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}