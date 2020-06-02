import 'dart:convert';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskStats extends StatefulWidget {
  @override
  _TaskStatsState createState() => _TaskStatsState();
}

class _TaskStatsState extends State<TaskStats> {
  int touchedIndex;
  List<TaskModel> tasks = sharedData.getTasks();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Estadísticas de las Tareas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.white70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Estadísticas Generales de Tareas'),
                  subtitle: Text('Estado actual de las tareas del piso'),
                ),
                _generalStats(),
              ],
            ),),
          Card(
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
              onTap: () async {
                await Navigator.pushNamed(context,'/rankingTasks');
              },//Link on press function
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.show_chart, color: Colors.white, size: 30,),
              ),
              title: Text('Ranking de las tareas',
                style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              trailing: Column(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                  Text('Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Card(
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
              onTap: () async {
                await Navigator.pushNamed(context,'/yourTaskStats');
              },//Link on press function
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.pie_chart, color: Colors.white, size: 30,),
              ),
              title: Text('Estadísticas de tus tareas',
                style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              trailing: Column(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                  Text('Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _generalStats(){
    if(tasks.length != 0) {
      return AspectRatio(
        aspectRatio: 1.8,
        child: Card(
          color: Colors.white,
          elevation: 12,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                            touchCallback: (pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse
                                    .touchInput is FlLongPressEnd ||
                                    pieTouchResponse.touchInput is FlPanEnd) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex =
                                      pieTouchResponse.touchedSectionIndex;
                                }
                              });
                            }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSectionsGeneralStatsTasks()),
                  ),
                ),
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  <Widget>[
                    Row(
                    children: <Widget>[
                    SizedBox(
                      width: 10.0,
                      height: 10.0,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                            color: Colors.green
                        ),
                      ),
                    ),
                      SizedBox(width: 5,),
                      Text('Hecho'),
                    ]),
                    SizedBox(height: 5,),
                    Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration: const BoxDecoration(
                                  color: Colors.grey
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Text('No hecho'),
                        ]),
                    SizedBox(height: 5,),

                  ]
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ),
      );
    }
    else{
      return Card(elevation: 12,child:Text('Estadísticas no disponibles'));
    }
  }

  //Here we set the value of the PieChart sections
  List<PieChartSectionData> showingSectionsGeneralStatsTasks() {
    int totalTasks = 0;
    int totalDoneTasks = 0;
    totalTasks = tasks.length;
    print('Total tasks: '+totalTasks.toString());
    for(int i =0;i<tasks.length;i++){
      print(tasks.elementAt(i).getDone().toString());
      if(tasks.elementAt(i).getDone() == true){
        totalDoneTasks++;
      }
    }
    print('Total done tasks: '+totalDoneTasks.toString());
    double totalPercentageDone = (totalDoneTasks/totalTasks)*100;
    double totalPercentatge = (1-(totalDoneTasks/totalTasks))*100;
    //Take the number of total tasks and the number of tasks done
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.grey,
            value: totalPercentatge,
            title: ''+totalPercentatge.toString().substring(0,3)+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: totalPercentageDone,
            title: ''+totalPercentageDone.toString().substring(0,3)+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),

          );
        default:
          return null;
      }
    });
  }
  Widget _detailedStats(){
    if(tasks.length != 0) {
      return AspectRatio(
        aspectRatio: 1.8,
        child: Card(
          color: Colors.white,
          elevation: 12,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                            touchCallback: (pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse
                                    .touchInput is FlLongPressEnd ||
                                    pieTouchResponse.touchInput is FlPanEnd) {
                                  touchedIndex = -1;
                                } else {
                                  touchedIndex =
                                      pieTouchResponse.touchedSectionIndex;
                                }
                              });
                            }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSectionsGeneralStatsTasks()),
                  ),
                ),
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  <Widget>[
                    Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration: const BoxDecoration(
                                  color: Colors.green
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Text('Hecho'),
                        ]),
                    SizedBox(height: 5,),
                    Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                            height: 10.0,
                            child: const DecoratedBox(
                              decoration: const BoxDecoration(
                                  color: Colors.grey
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Text('No hecho'),
                        ]),
                    SizedBox(height: 5,),

                  ]
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ),
      );
    }
    else{
      return Card(elevation: 12,child:Text('Estadísticas no disponibles'));
    }
  }

}
