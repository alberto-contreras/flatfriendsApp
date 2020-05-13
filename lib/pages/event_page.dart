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
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Flat Events'),
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButton: FlatButton(onPressed: () async{
        await Navigator.pushNamed(context,'/regevent');
      //we put in a dynamic variable because when are doing a big async task
      //first we go to the event page and then after adding a new one we pop with a refresh
        await flatService.getEventFlat();
        setState(() { });
        }, child: Text('Add Event'),
        shape: StadiumBorder(),
        color: Colors.purple,
        textColor: Colors.white),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical:1.0, horizontal: 4.0),
          itemCount: events.length,
          itemBuilder: (context,index){ //This function will make a widget tree of the one we choose
            return Card(
                child: ListTile(
                  onTap: (){
                  },//Link on press function
                  title: Text(events.elementAt(index).getName().toString()+' ('+events.elementAt(index).getOrganizer().toString()+')'),
                  subtitle: Text(events.elementAt(index).getDescription().toString()+'\n'+events.elementAt(index).getDate().toString()),

                ),
            );
          },),
    );
  }
}