import 'dart:ffi';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flatfriendsapp/transitions/horizontal_transition_right_to_left.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:share/share.dart';
import 'package:latlong/latlong.dart';

import 'home_page.dart';

class Flat extends StatefulWidget {
  _FlatState createState() => _FlatState();
}
SharedData sharedData = SharedData.getInstance();

class _FlatState extends State<Flat> {
  bool _visible = false;
  String text = '';
  String subject = '';
  List<Color> colorList = new List<Color>();
  List<UserModel> tenants = sharedData.getTenants();
  int _selectedIndex = 2;
  static const TextStyle cardHeader = TextStyle(fontSize: 20, color: Colors.white, shadows: <Shadow>[
    Shadow(
      offset: Offset(1.5, 1.5),
      blurRadius: 7.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],);
  static const TextStyle inCard = TextStyle(fontSize: 15, color: Colors.white, fontStyle: FontStyle.italic, shadows: <Shadow>[
    Shadow(
      offset: Offset(1, 1),
      blurRadius: 5.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],);
  static const TextStyle tilesStyle = TextStyle(
    fontSize: 30, fontWeight: FontWeight.bold, );
  static const TextStyle inMainCardStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent);
  static const TextStyle inMainCardInfoStyle = TextStyle(
      fontSize: 18, color: Colors.black, fontStyle: FontStyle.italic);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
      ),
      body: Padding(padding: const EdgeInsets.only(left: 16, top: 16),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ColorizeAnimatedTextKit(
                      text: [
                        "Perfil del piso:"
                      ],
                      textStyle: tilesStyle,
                      colors: [
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                        Colors.red,
                      ],
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center // or Alignment.topLeft
                  ),
                  SizedBox(height: 8,),
                  _showFlatData(),
                  SizedBox(height: 16,),
                  ColorizeAnimatedTextKit(
                      text: [
                        "Tus Flat Friends:"
                      ],
                      textStyle: tilesStyle,
                      colors: [
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                        Colors.red,
                      ],
                      textAlign: TextAlign.center,
                      alignment: AlignmentDirectional.center // or Alignment.topLeft
                  ),
                  _tenantsInfo(),
                ],
              ),
            ],
          )
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('User'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Flat'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void initState() {
    super.initState();

    // Method to load a widget after full loaded page
    colorList.add(Colors.pink[100]);
    colorList.add(Colors.blue[100]);
    colorList.add(Colors.green[200]);
    colorList.add(Colors.yellow[200]);
    colorList.add(Colors.deepPurple[100]);
    colorList.add(Colors.red[100]);
    colorList.add(Colors.orange[100]);
    colorList = (colorList..shuffle());
  }

  // Do an action depending on the pushed button from bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.of(context).pop();
          Navigator.push(context,
              EnterLeftExitRightRoute(exitPage: Flat(), enterPage: User()));
          break;
        case 1:
          Navigator.of(context).pop();
          Navigator.push(context,
              EnterLeftExitRightRoute(exitPage: Flat(), enterPage: Home()));
          break;
      }
    });
  }

  Widget _tenantsInfo() {
    if (sharedData.getTenants() != null && sharedData
        .getTenants()
        .length != 0) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: tenants.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context,
            index) { //This function will make a widget tree of the one we choose
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              elevation: 2,
              color: colorList[index],
              margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile( //  Inside a theme in order to delete the divider color of expansion tile
                      title: Text(tenants.elementAt(index).getFirstname() + ' ' +
                          tenants.elementAt(index).getLastname(), style: cardHeader,),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 1.0,
                                        top: 2.0,
                                        child: Icon(
                                            Icons.email, color: Colors.black12),
                                      ),
                                      Icon(Icons.email, color: Colors.white,),
                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    tenants.elementAt(index).getEmail(),
                                    style: inCard,),
                                ],
                              ),
                              if (tenants.elementAt(index).getPhoneNumber() !=
                                  null) Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 1.0,
                                        top: 2.0,
                                        child: Icon(
                                            Icons.phone, color: Colors.black12),
                                      ),
                                      Icon(Icons.phone, color: Colors.white,),
                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                  Text(tenants.elementAt(index).getPhoneNumber(),
                                    style: inCard,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              )
          );
        },
      );
    }
    else {
      return Text('   No tienes compañeros de piso.', style: inMainCardStyle);
    }
  }

  Widget _showFlatData() {
    if (sharedData.getFlat() != null) {
      return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          elevation: 2,
          margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
          child: Container(
            padding: EdgeInsets.only(right: 10, left: 3, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre:', style: inMainCardStyle),
                      SizedBox(height: 5),
                      Text('   ' + sharedData.getFlat().getName(),
                        style: inMainCardInfoStyle,),
                      SizedBox(height: 10),
                      Text('Descripción:', style: inMainCardStyle),
                      SizedBox(height: 5),
                      Text('   ' + sharedData.getFlat().getDescription(),
                        style: inMainCardInfoStyle,),
                      SizedBox(height: 10),
                      Text('Número máximo de inquilinos:', style: inMainCardStyle),
                      SizedBox(height: 5),
                      Text('   ' + sharedData.getFlat().getMaxPersons().toString(),
                        style: inMainCardInfoStyle,),
                      SizedBox(height: 10),
                      Text('Identificador:', style: inMainCardStyle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (!_visible)Text('   ••••••••••••••••••••••••',
                            style: inMainCardInfoStyle,),
                          if (_visible)Text('   ' + sharedData.getFlat().getID(),
                            style: inMainCardInfoStyle,),
                          Row(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 14.0,
                                    top: 14.0,
                                    child: Icon(Icons.remove_red_eye, color: Colors
                                        .black26,),
                                  ),
                                  IconButton(
                                      icon: new Icon(Icons.remove_red_eye,
                                        color: Colors.lightBlue,),
                                      onPressed: () {
                                        setState(() {
                                          _visible = !_visible;
                                        });
                                      }
                                  ),
                                ],
                              ),
                              Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 14.0,
                                    top: 14.0,
                                    child: Icon(Icons.share, color: Colors.black26,),
                                  ),
                                  IconButton(
                                      icon: new Icon(Icons.share, color: Colors
                                          .lightBlue,),
                                      onPressed: () {
                                        Share.share(
                                            '¡Únete a mi piso en Flat&Friends! ' +
                                                sharedData.getUser().getIdPiso());
                                      }
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

            Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Localización:', style: inMainCardStyle),
                    children: [
                      Container(
                          height: 300,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 75.0,
                          child: FlutterMap(
                            options: new MapOptions(
                                center: new LatLng(double.parse(
                                    sharedData.getFlat()
                                        .getLocation()
                                        .getLatitude()), double.parse(
                                    sharedData.getFlat()
                                        .getLocation()
                                        .getLongitude())),
                                zoom: 14.4746,
                                interactive: false
                            ),
                            layers: [
                              new TileLayerOptions(
                                urlTemplate: "https://api.mapbox.com/styles/v1/grupo1ea/ckamlz1jw4x661ilkwv5djupf/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ3J1cG8xZWEiLCJhIjoiY2thbWR1aWYyMGo4YTJ5cXdzMnM1ZHV1cCJ9.hFVy8x411MXAGB9AAVZUqQ",
                                additionalOptions: {
                                  'accessToken': 'pk.eyJ1IjoiZ3J1cG8xZWEiLCJhIjoiY2thbWR1aWYyMGo4YTJ5cXdzMnM1ZHV1cCJ9.hFVy8x411MXAGB9AAVZUqQ',
                                  'id': 'mapbox.streets',
                                },
                              ),
                              new MarkerLayerOptions(
                                markers: [Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: new LatLng(double.parse(
                                      sharedData.getFlat()
                                          .getLocation()
                                          .getLatitude()), double.parse(
                                      sharedData.getFlat()
                                          .getLocation()
                                          .getLongitude())),
                                  builder: (ctx) =>
                                  new Container(
                                      child: new Icon(
                                        Icons.location_on, color: Colors.red,
                                        size: 45.0,)
                                  ),
                                )
                                ],
                              ),
                            ],
                          )
                      ),
                    ],
                  )
              ),

                  ],
            ),
          )
      );
    }
    else {
      return Text('   No estás registrado en un piso.', style: inMainCardStyle);
    }
  }

}