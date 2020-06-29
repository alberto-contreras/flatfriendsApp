import 'dart:async';

import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:latlong/latlong.dart';

class RegisterFlat extends StatefulWidget {
  _RegisterFlat createState() => _RegisterFlat();
}

class _RegisterFlat extends State<RegisterFlat> {
  Completer<FlutterMap> _controller = Completer();
  List<Marker> _markers = [];

  // Por defecto introducimos las coordenadas de Barcelona
  String latitude = '41.3887901';
  String longitude = '2.1589899';

  TextEditingController flatNameController = new TextEditingController();
  TextEditingController flatDescriptionController = new TextEditingController();
  TextEditingController maxPersonsController = new TextEditingController();
  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  FlatModel flat = new FlatModel();
  FlatService flatService = new FlatService();
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    _markers.add(Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(41.3887901, 2.1589899),
      builder: (ctx) =>
      new Container(
        padding: EdgeInsets.only(bottom: 23.0),
          child: new Icon(Icons.location_on, color: Colors.red, size: 45.0,)
      ),
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Registrar un nuevo piso:', style: optionStyle),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Datos del piso:', style: labelStyle),
                  SizedBox(height: 10,),
                  _textFlatName(),
                  SizedBox(height: 10,),
                  _textFlatDescription(),
                  SizedBox(height: 10,),
                  _textMaxPersons(),
                  SizedBox(height: 30,),
                  Text('Localización del piso:', style: labelStyle),
                  SizedBox(height: 10,),
                  Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: FlutterMap(
                        options: new MapOptions(
                            center: new LatLng(41.3887901, 2.1589899),
                            zoom: 14.4746,
                            onTap: (position) => moveMarker(position)
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
                            markers: _markers,
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _registerButton(), // Creating a button widget for Login
                      SizedBox(width: 60,),
                      _cancelButton()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _textFlatName(){
    return TextField(
      controller: flatNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Nombre del piso',
          hintText: 'Escribe el nombre del piso',
          suffixIcon: Icon(Icons.home, color: Colors.blue),
          icon: Icon(Icons.business)
      ),
    );
  }

  Widget _textFlatDescription(){
    return TextField(
      controller: flatDescriptionController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Descripción del piso',
          hintText: 'Escribe si quieres una descripción',
          suffixIcon: Icon(Icons.assignment, color: Colors.blue),
          icon: Icon(Icons.assignment)
      ),
    );
  }

  Widget _textMaxPersons(){
    return TextField(
      controller: maxPersonsController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Número máximo de inquilinos',
          hintText: 'Indica la cantidad máxima de inquilinos',
          suffixIcon: Icon(Icons.assignment, color: Colors.blue),
          icon: Icon(Icons.assignment)
      ),
    );
  }

  Widget _registerButton() {
    return FlatButton(onPressed: () async {
      print('Dentro Registro de piso');
      if (flatNameController.text != '' && maxPersonsController.text != '') {
        flat.setName(flatNameController.text);
        flat.setDescription(flatDescriptionController.text);
        flat.setFull(false);
        flat.setMaxPersons(int.parse(maxPersonsController.text));
        flat.setLocation(latitude, longitude);
        print("latitude def: " + flat.getLocation().getLatitude() + ", longitude def: " + flat.getLocation().getLongitude());
        int res = await flatService.registerFlat(flat);
        print(res);
        if (res == 0) {
          if (sharedData.getIdChatRoom() != sharedData.getUser().getIdPiso()) {
            sharedData.setChatRoomStatus(false);
            print('PISO DIFERENTEEEE, LOGINNNN');
          }
          if (sharedData.getChatRoomStatus() == false){
            await sharedData.chatService.initChatService(
                sharedData.getUser().getIdPiso());
          }
          sharedData.chatRunning = true;
          Navigator.pop(context, () {
            setState(() {});
          });
          _warningOnTryRegFlat(res);
        }
        else {
          //Error adding new flat
          _warningOnTryRegFlat(res);
//          showDialog<void>(
//              context: context,
//              builder: (BuildContext context) {
//                return _alertRegisterFlat();
//              });
        }
      }
      else{
        //Empty fields
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertEmptyFields();
            });
      }
    },
        child: Text('Registrar piso'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _cancelButton() {
    return FlatButton(onPressed: () {
      Navigator.pop(context);
    },
        child: Text('Cancelar'),
        shape: StadiumBorder(),
        color: Colors.red,
        textColor: Colors.white);
  }

  Widget _alertRegisterFlat() {
    return PlatformAlertDialog(
      title: Text('Error'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Error en el registro vuelve a intentarlo.'),
            Text('Ayuda: Revisa los datos del piso.'),
          ],
        ),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _alertEmptyFields() {
    return PlatformAlertDialog(
      title: Text('Hey!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Error en el registro vuelve a intentarlo.'),
            Text('Ayuda: Revisa los datos del piso.'),
          ],
        ),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  moveMarker(position) {
    setState(() {
      print(position);
      _markers[0] = Marker(
        width: 80.0,
        height: 80.0,
        point: position,
        builder: (ctx) =>
        new Container(
            child: new Icon(Icons.location_on, color: Colors.red, size: 45.0,)
        ),
      );
      longitude = _markers[0].point.longitude.toString();
      print('longitude: ' + longitude);
      latitude = _markers[0].point.latitude.toString();
      print('latitude: ' + latitude);
    });
  }

  Widget _warningOnTryRegFlat(int res) {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            title: Text('¡Has registrado tu piso!'),
            content: Text('¡Gracias por usar Flat&Friends!'),
            actions: <Widget>[
              if (res == 0) Column(
                children: <Widget>[
                  FlatButton(
                      child: Text('Aceptar'),
                      shape: StadiumBorder(),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                  ),
                ],
              ),
              if (res != 0) Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (res != 2)Text('Vaya... Parece que ha habido algún problema.' + '\n' +
                      'Por favor, revisa el identificador e inténtalo de nuevo.'),
                  if (res == 2)Text('¡Este piso ya está lleno! Contacta con el Flat admin.'),
                  SizedBox(height: 10,),
                  FlatButton(
                      child: Text('Volver a intentar'),
                      shape: StadiumBorder(),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

}
