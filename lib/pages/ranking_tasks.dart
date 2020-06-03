import 'dart:convert';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RankingTasks extends StatefulWidget {
  @override
  _RankingTasksState createState() => _RankingTasksState();
}

class _RankingTasksState extends State<RankingTasks> {
  @override
  Widget build(BuildContext context) {
    int i=0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Ranking de las Tareas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
       child: Container(
         padding: EdgeInsets.all(5),
         child: Column(
           children: <Widget>[
             Card(
               color: Colors.white70,
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   ListTile(
                     leading: Icon(Icons.assignment_turned_in),
                     title: Text('Ranking General de Tareas'),
                     subtitle: Text('Quien ha trabajado más hasta esta semana'),
                   ),
                   /**
                    * Ranking of the users of the flat and their total amount of tasks
                    */
                   ListView.builder(
                     itemCount:sharedData.getTenants().length,
                     shrinkWrap: true,
                     itemBuilder: (context, index) {
                       i++;
                       return Card(
                         margin: const EdgeInsets.only(
                           top: 16.0,
                           bottom: 1.0,
                           left: 24.0,
                           right: 24.0,
                         ),
                         color: Colors.black,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(11.0),
                         ),

                         child: ListTile(
                           onTap: () {
                           },//Link on press function
                           leading: Container(
                             padding: EdgeInsets.only(right: 12.0),
                             decoration: new BoxDecoration(
                                 border: new Border(
                                     right: new BorderSide(width: 1.0, color: Colors.white24))),
                             child: Text(''+i.toString(),style: TextStyle(
                               color: Colors.white, fontSize: 20,
                             ),),

                           ),
                           title: Text(''+sharedData.getTenants().elementAt(index).getFirstname(),
                             style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                           trailing: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Text('Tareas: '+sharedData.getTenants().elementAt(index).getAllTasks().toString(), style: TextStyle(
                                 color: Colors.white, fontSize: 20,)),
                             ],
                           ),
                         ),
                       );
                     },),
                 ],
               ),),
             Card(
               margin: const EdgeInsets.only(
                 top: 16.0,
                 bottom: 1.0,
                 left: 24.0,
                 right: 24.0,
               ),
               color: Colors.grey,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(11.0),
               ),

               child: ListTile(
                 onTap: () {
                 },//Link on press function
                 leading: Container(
                   padding: EdgeInsets.only(right: 12.0),
                   decoration: new BoxDecoration(
                       border: new Border(
                           right: new BorderSide(width: 1.0, color: Colors.white24))),
                   child: Icon(Icons.person),

                 ),
                 title: Text('Tú',
                   style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                 trailing: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Text('Tareas: '+sharedData.getUser().getAllTasks().toString(), style: TextStyle(
                       color: Colors.white, fontSize: 20,)),
                   ],
                 ),
               ),)
           ],
         ),
       ),
      )
    );
  }


}
