import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


SharedData sharedData = SharedData.getInstance();

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  EventModel event = sharedData.getEventDetails();

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
                      ""+event.getName(),
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
                    alignment: AlignmentDirectional.topCenter // or Alignment.topLeft
                ),
              ),
            ),
            Divider(
              height: 30,
              color: Colors.black,
            ),
            Text(
              'Organizador: ' ,
               style: TextStyle(
                color: Colors.black,
                 fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            Text(
              ''+event.getOrganizer(),
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
              ''+event.getDescription(),
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
              ''+event.getDate(),
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
            Text(
              '',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20,),
            Row(

              children: <Widget>[
                FlatButton.icon(onPressed: (){},
                  icon: Icon(Icons.assignment_turned_in),
                  label: Text('Aceptar Evento'),
                  shape: StadiumBorder(),
                  color: Colors.green,
                  textColor: Colors.white ,),
                SizedBox(width: 20),
                FlatButton.icon(onPressed: (){},
                  icon: Icon(Icons.assignment_late),
                  shape: StadiumBorder(),
                  color: Colors.red,
                    textColor: Colors.white,
                  label: Text('Rechazar Evento'),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}