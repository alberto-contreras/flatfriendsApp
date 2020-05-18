import 'dart:convert';

import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:http/http.dart'as http;

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<TaskModel> tasks = sharedData.getTasks();
  FlatService flatService = new FlatService();
  //This function it's going use getTime on wherever instance and then once we have the data re root to the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Flat Tasks'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FlatButton(onPressed: () async{
        await Navigator.pushNamed(context,'/regtask');
        //we put in a dynamic variable because when are doing a big async task
        //first we go to the task page and then after adding a new one we pop with a refresh
        await flatService.getTaskFlat();
        setState(() { });
      }, child: Text('Add Task'),
          shape: StadiumBorder(),
          color: Colors.purple,
          textColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical:1.0, horizontal: 4.0),
        itemCount: tasks.length,
        itemBuilder: (context,index){ //This function will make a widget tree of the one we choose
          return Card(
            child: ListTile(
              onTap: (){
              },//Link on press function
              title: Text(tasks.elementAt(index).getTittle().toString()+' ('+tasks.elementAt(index).getIdUser.toString()+')'),
              subtitle: Text(tasks.elementAt(index).getDescription().toString()+'\n'),

            ),
          );
        },),
    );
  }
}