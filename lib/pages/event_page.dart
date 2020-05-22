import 'dart:convert';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:http/http.dart'as http;

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  List<EventModel> events = sharedData.getEvents();
  FlatService flatService = new FlatService();
  //This function it's going use getTime on wherever instance and then once we have the data re root to the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Eventos del Piso'),
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButton: FlatButton(onPressed: () async{
          await flatService.getUsersFlat();
        await Navigator.pushNamed(context,'/regevent');
      //we put in a dynamic variable because when are doing a big async task
      //first we go to the event page and then after adding a new one we pop with a refresh
        await flatService.getEventFlat();
        setState(() { });
        }, child: Text('Añadir Evento'),
        shape: StadiumBorder(),
        color: Colors.purple,
        textColor: Colors.white),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical:1.0, horizontal: 4.0),
          itemCount: events.length,
          itemBuilder: (context,index){ //This function will make a widget tree of the one we choose

            return Card(
                margin: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 1.0,
                  left: 24.0,
                  right: 24.0,
                ),
                color: Colors.blue[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0),
              ),

                child: ListTile(
                  onTap: () async {
                    print(events.elementAt(index).getName().toString());
                    sharedData.setEventDetails(events.elementAt(index));
                    await Navigator.pushNamed(context,'/eventDetails');
                    //we put in a dynamic variable because when are doing a big async task
                    //first we go to the event page and then after adding a new one we pop with a refresh
                    await flatService.getEventFlat();
                  },//Link on press function
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.event, color: Colors.white, size: 30,),
                  ),
                  title: Text(events.elementAt(index).getName().toString()+' ('+events.elementAt(index).getOrganizer().toString()+')',
                    style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                            // tag: 'hero',
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                value: getAccept(index),
                                valueColor: AlwaysStoppedAnimation(Colors.green)),
                          )),
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Aceptación',
                                style: TextStyle(color: Colors.white))),
                      )
                    ],
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                      Text('Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),

                ),
            );
          },),
    );
  }
  double getAccept(int position){
    double accept = 0;
    for(int i = 0; i<events.elementAt(position).getUsers().length;i++){
      if(events.elementAt(position).getUsers().elementAt(i).getStatus() == '1'){
        accept = accept +1;
      }
    }
    double percent = accept/events.elementAt(position).getUsers().length;
    return percent;
  }
}
