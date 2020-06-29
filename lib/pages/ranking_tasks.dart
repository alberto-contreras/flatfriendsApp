import 'dart:convert';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class RankingTasks extends StatefulWidget {
  @override
  _RankingTasksState createState() => _RankingTasksState();
}

class _RankingTasksState extends State<RankingTasks> {
  List<UserModel> tenentsForChart = List<UserModel>();
  bool toggle = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.white,
    Colors.purple
  ];
  @override
  Widget build(BuildContext context) {
    int i=0;
    tenentsForChart.addAll(sharedData.getTenants());
    tenentsForChart.add(sharedData.getUser());
    tenentsForChart.sort((a, b) => b.getAllTasks().compareTo(a.getAllTasks()));
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
                     itemCount:tenentsForChart.length,
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
                         elevation: 20,
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
                           title: Text(''+tenentsForChart.elementAt(index).getFirstname(),
                             style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                           trailing: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Text('Tareas: '+tenentsForChart.elementAt(index).getAllTasks().toString(), style: TextStyle(
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
                 elevation: 12,
                 color: Colors.white70,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(11.0),
                 ),
                 child: _pieChart() ),
           ],
         ),
       ),
      )
    );
  }

  /**
   * PieChart of the ranking (another view)
   */
  Widget _pieChart(){

   for(int i =0; i < tenentsForChart.length;i++){
     dataMap.putIfAbsent(""+tenentsForChart.elementAt(i).getFirstname(), () => tenentsForChart.elementAt(i).getAllTasks().toDouble());
   }
     return  Container(
        child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            showChartValuesInPercentage: true,
            showChartValues: true,
            showChartValuesOutside: false,
            chartValueBackgroundColor: Colors.grey[200],
            colorList: colorList,
            showLegends: true,
            legendPosition: LegendPosition.right,
            decimalPlaces: 1,
            showChartValueLabel: true,
            initialAngle: 0,
            chartValueStyle: defaultChartValueStyle.copyWith(
              color: Colors.blueGrey[900].withOpacity(0.9),
            ),
            chartType: ChartType.disc,
          ),
      );
  }

}
