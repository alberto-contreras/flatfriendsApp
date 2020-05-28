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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Detalles de Evento'),
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
                        fontSize: 40.0,
                        fontFamily: "Horizon",
                        fontWeight: FontWeight.bold,
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
              '' + event.getDate().substring(0,16),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Estado: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            _showNumberOfAccept(),
            SizedBox(height: 20,),
            _showNumberOfDecline(),
            SizedBox(height: 20,),
            _showAcceptDecline(),
          ],
        ),
      ),
    );
  }


  Widget _showAcceptDecline() {
    bool found = false;
    bool exist = false;
    for (int i = 0; i < event.getUsers().length; i++) {
      //Comprobamos que el usuario no tenga el estado a 1 o a 2, es decir ya haya aceptado o rechazado el evento
      if ((event.getUsers().elementAt(i).getId() == sharedData.getUser().getIdUser()) && (event.getUsers().elementAt(i).getStatus() != '0')) {
        found = true;
        print('YA HE VOTADO');
      }
    }
    int i=0;
    while(!exist){
      //Comprobamos que el usuario se encuentre o no en la lista del evento y en caso de que no se encuentre
      //mostrale el mensaje de "No pertenecias al piso cuando se creo el evento"
      if(event.getUsers().elementAt(i).getId() == sharedData.getUser().getIdUser()) {
        exist = true;
        break;
      }
      else{
        i++;
      }
      if(i >= event.getUsers().length){
         break;
      }

    }

    if (found != true && exist == true) {
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
    else if(found == true && exist == true){
      return Card(
        margin: const EdgeInsets.only(
          top: 16.0,
          bottom: 1.0,
          left: 10.0,
          right: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0),
        ),
        color:Colors.deepPurple,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 5.0)),
            Icon(Icons.all_inclusive,color: Colors.white70,),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Text('Gracias por dar tu opinión sobre el evento',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold

            ),)
          ],
        ),
      );
    }
    else if(exist == false){
      return Card(
        margin: const EdgeInsets.only(
          top: 16.0,
          bottom: 1.0,
          left: 10.0,
          right: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0),
        ),
        color:Colors.deepPurple,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 5.0)),
            Icon(Icons.all_inclusive,color: Colors.white70,),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Text('No estabas en el piso durante el evento',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold

              ),)
          ],
        ),
      );
    }
  }

  //Here we show de stadistics about how many people have accept this event
  Widget _showNumberOfAccept() {
    List <String> usernameAccepted = new List <String>();
    int accept = 0;
    for(int i = 0; i<event.getUsers().length;i++){
      if(event.getUsers().elementAt(i).getStatus() == '1'){
        accept = accept +1;
        print(event.getUsers().elementAt(i).getFirstname());
        usernameAccepted.add(event.getUsers().elementAt(i).getFirstname());
      }
    }
    return Column(
      children:<Widget>[
        ExpansionTile(
          backgroundColor: Colors.green[100],
          title: Row(
          children: <Widget>[
            Icon(Icons.thumb_up,size:20 ,color: Colors.green,),
            SizedBox(width: 20),
            Expanded(
                flex: 1,
                child: Container(
                  height: 10,
                  width: 20,
                  // tag: 'hero',
                  child: LinearProgressIndicator(

                      backgroundColor: Colors.grey[100],
                      value: getAccept(),
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Aceptan el evento '+accept.toString()+'/'+event.getUsers().length.toString()+' personas',
                      style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold, fontSize: 14))),
            ),
          ],
        ),
        children: <Widget>[
            ListView.builder(
             itemCount:usernameAccepted.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
               return Text('   ' + usernameAccepted.elementAt(index).toString(),
                     style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold, fontSize: 18),);
               },),
          SizedBox(height: 20,)
        ],)],
    );

  }

  //Here we show de stadistics about how many people have decline this event
  Widget _showNumberOfDecline() {
    List <String> usernameDecline = new List <String>();
    int decline = 0;
    for (int i = 0; i < event
        .getUsers()
        .length; i++) {
      if (event.getUsers().elementAt(i).getStatus() == '2') {
        decline = decline + 1;
        usernameDecline.add(event.getUsers().elementAt(i).getFirstname());
      }
    }
    return Column(
      children: <Widget>[
        ExpansionTile(
          backgroundColor: Colors.red[100],
          title: Row(
            children: <Widget>[
              Icon(Icons.thumb_down, size: 20, color: Colors.red,),
              SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 10,
                    width: 20,
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[100],
                        value: getDecline(),
                        valueColor: AlwaysStoppedAnimation(Colors.red)),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                        'No aceptan el evento ' + decline.toString() + '/' +
                            event
                                .getUsers()
                                .length
                                .toString() + ' personas',
                        style: TextStyle(color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 14))),
              ),
            ],
          ),
          children: <Widget>[
            if (usernameDecline.length == 0) Column(
              children: [
                SizedBox(height: 10,),
                Text('   No hay votos negativos.',
                    style: TextStyle(color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            if (usernameDecline.length > 0) ListView.builder(
              itemCount: usernameDecline.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print(index);
                return Text(' ' + usernameDecline.elementAt(index).toString(),
                    style: TextStyle(color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18));
              },),
            SizedBox(height: 20,)
          ],
        )
      ],
    );
  }

  //We get the percent of accept
  double getAccept(){
    double accept = 0;
    for(int i = 0; i<event.getUsers().length;i++){
      if(event.getUsers().elementAt(i).getStatus() == '1'){
        accept = accept +1;
      }
    }
    double percent = accept/event.getUsers().length;
    return percent;
  }
  //We get the percent of decline
  double getDecline(){
    double decline = 0;
    for(int i = 0; i<event.getUsers().length;i++){
      if(event.getUsers().elementAt(i).getStatus() == '2'){
        decline = decline +1;
      }
    }
    double percent = decline/event.getUsers().length;
    return percent;
  }
}