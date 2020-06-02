import 'dart:convert';
import 'dart:ffi';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class YourTaskStats extends StatefulWidget {
  @override
  _YourTaskStatsState createState() => _YourTaskStatsState();
}

class _YourTaskStatsState extends State<YourTaskStats> {
  List<TaskModel> tasks = sharedData.getTasks();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Estadísticas de tus Tareas'),
    centerTitle: true,
    elevation: 0,
    ),
    body:Column(
      children: <Widget>[
        Card(
          elevation: 20,
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

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.insert_chart,color: Colors.white,size: 40,),
                title: Text('Tus Tareas ',style:
                  TextStyle(color: Colors.white,),),
                subtitle: Text('Pendientes y finalizada',style:
                TextStyle(color: Colors.white,),),
              ),
              _getData(),
            ],
          ),

        ),
      ],
    ),);
  }






  Widget _getData(){
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.grey[800],
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                    ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'TAREAS PENDIENTES';
                    case 1:
                      return 'TOTAL TAREAS';

                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: [
              BarChartGroupData(
                  x: 0,
                  barRods: [BarChartRodData(y: calcActualTasks(), color: Colors.lightBlueAccent)],
                  showingTooltipIndicators: [0]),

              BarChartGroupData(
                  x: 3,
                  barRods: [BarChartRodData(y: sharedData.getUser().getAllTasks().toDouble(), color: Colors.green)],
                  showingTooltipIndicators: [0]),
            ],
          ),
        ),
      ),
    );
  }

  double calcActualTasks(){
    int notFinished = 0;
    for(int i=0; i < tasks.length;i++){
      if(tasks.elementAt(i).getIdUser() == sharedData.getUser().getIdUser() && tasks.elementAt(i).getDone() == false){
        notFinished++;
      }
    }
    return notFinished.toDouble();
  }

}
