import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:platform_alert_dialog/platform_alert_dialog.dart';


SharedData sharedData = SharedData.getInstance();

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  EventModel event = sharedData.getEventDetails();
  FlatService flatService = new FlatService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Event Details'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: SizedBox(

                width: 250.0,
                child: ColorizeAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "" + event.getName(),
                    ],
                    textStyle: TextStyle(
                        fontSize: 30.0,
                        fontFamily: "Horizon"
                    ),
                    colors: [
                      Colors.purple,
                      Colors.blue,

                      Colors.red,
                    ],
                    textAlign: TextAlign.center,
                    alignment: AlignmentDirectional
                        .topCenter // or Alignment.topLeft
                ),
              ),
            ),
            Divider(
              height: 30,
              color: Colors.black,
            ),
            Text(
              'Organizador: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            Text(
              '' + event.getOrganizer(),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0), //Space between two widgets
            Text(
              'Descripción: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            Text(
              '' + event.getDescription(),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Fecha: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            Text(
              '' + event.getDate(),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Aceptación: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            _showNumberOfAccept(),
            SizedBox(height: 20,),
            _showAcceptDecline(),
          ],
        ),
      ),
    );
  }


  Widget _showAcceptDecline() {
    bool encontrado = false;
    for (int i = 0; i < event
        .getUsers()
        .length; i++) {
      //Comprobamos que el usuario no tenga el estado a 1 o a 2, es decir ya haya aceptado o rechazado el evento
      if ((event.getUsers().elementAt(i).getId() ==
          sharedData.getUser().getIdUser()) &&
          (event.getUsers().elementAt(i).getStatus() != '0')) {
        encontrado = true;
      }
    }
    if (encontrado != true) {
      return Row(

        children: <Widget>[
          //Hemos de actualizar la lista con el estado que ha decidio el usuario y enviarla (estado = 1) --> ACEPTADO
          FlatButton.icon(onPressed: () async {
            for (int i = 0; i < event
                .getUsers()
                .length; i++) {
              if (event.getUsers().elementAt(i).getId() ==
                  sharedData.getUser().getIdUser()) {
                event.getUsers().elementAt(i).setStatus('1');
                int res = await flatService.updateEventFlat(event);
                if (res == 0) {
                  Navigator.pop(context);
                }
                else {
                  print('Error');
                }
              }
            }
          },
            icon: Icon(Icons.assignment_turned_in),
            label: Text('Aceptar Evento'),
            shape: StadiumBorder(),
            color: Colors.green,
            textColor: Colors.white,),
          SizedBox(width: 20),
          //Hemos de actualizar la lista con el estado que ha decidio el usuario y enviarla (estado = 2) --> RECHAZADO
          FlatButton.icon(onPressed: () async {
            for (int i = 0; i < event
                .getUsers()
                .length; i++) {
              if (event.getUsers().elementAt(i).getId() ==
                  sharedData.getUser().getIdUser()) {
                event.getUsers().elementAt(i).setStatus('2');
                int res = await flatService.updateEventFlat(event);
                if (res == 0) {
                  Navigator.pop(context);
                }
                else {
                  print('Error');
                }
              }
            }
          },
            icon: Icon(Icons.assignment_late),
            shape: StadiumBorder(),
            color: Colors.red,
            textColor: Colors.white,
            label: Text('Rechazar Evento'),

          ),
        ],
      );
    }
    else {
      return Row(

        children: <Widget>[

        ],
      );
    }
  }


  Widget _showNumberOfAccept() {
    int accept = 0;
    for(int i = 0; i<event.getUsers().length;i++){
      if(event.getUsers().elementAt(i).getStatus() == '1'){
        accept = accept +1;
      }

    }
    return Text(
      accept.toString()+'/'+event.getUsers().length.toString(),
      style: TextStyle(
        color: Colors.blue[800],
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),);
  }
}