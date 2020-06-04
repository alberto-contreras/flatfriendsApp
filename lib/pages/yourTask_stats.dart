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
  int totalTasksWeek = 0;
  int totalDoneTasksWeek = 0;
  int touchedIndex;
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
                title: Text('Tus estadísticas de Tareas',style:
                  TextStyle(color: Colors.white,),),
                subtitle: Text('Pendientes y Total',style:
                TextStyle(color: Colors.white,),),
              ),
              _getData(),
            ],
          ),

        ),
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.pie_chart,color: Colors.white,size: 40,),
                title: Text('Progreso de tus Tareas esta semana ',style:
                TextStyle(color: Colors.white,),),
                subtitle: Text('Pendientes y finalizadas',style:
                TextStyle(color: Colors.white,),),
              ),
              _generalStats()
            ],
          ),

        ),
      ],
    ),);
  }
  /**
   * Widget that represents the discrete chart about all your tasks ever
   * and the tasks that are not finished now
   */
  Widget _getData(){
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.white,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 50,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 10,
                getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                    ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.black,
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
  /**
   * Calculate all the tasks of the user this week and also the ones that have already done
   */
  double calcActualTasks(){
    int notFinished = 0;
    for(int i=0; i < tasks.length;i++){
      if(tasks.elementAt(i).getIdUser() == sharedData.getUser().getIdUser() && tasks.elementAt(i).getDone() == false){
        notFinished++;
      }
    }
    return notFinished.toDouble();
  }

  /**
   * Widget that represent the chart about the tasks of the week inside the flat of the user
   */
  Widget _generalStats(){
    if(tasks.length != 0) {
      return AspectRatio(
        aspectRatio: 1.5,
        child: Card(
          color: Colors.white,
          elevation: 12,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 30,

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
                          Text('Finalizadas'),
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
                          Text('Pendientes'),
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

  void totalTasksAndDone(){

    totalTasksWeek = 0;
    totalDoneTasksWeek = 0;
    print('Total tasks: '+totalTasksWeek.toString());
    for(int i =0;i<tasks.length;i++){
      print(tasks.elementAt(i).getDone().toString());
      if(tasks.elementAt(i).getDone() == true && tasks.elementAt(i).getIdUser() == sharedData.getUser().getIdUser()){
        totalDoneTasksWeek++;
        totalTasksWeek++;
      }
      else if(tasks.elementAt(i).getDone() != true && tasks.elementAt(i).getIdUser() == sharedData.getUser().getIdUser()){
        totalTasksWeek++;
      }
    }

  }
/**
 * List of values of the chart in order to represent it
 * //Here we set the value of the PieChart sections
 */
  List<PieChartSectionData> showingSectionsGeneralStatsTasks() {
    totalTasksAndDone();
    print('Total done tasks: '+totalDoneTasksWeek.toString());
    double totalPercentageDone = (totalDoneTasksWeek/totalTasksWeek)*100;
    double totalPercentatge = (1-(totalDoneTasksWeek/totalTasksWeek))*100;
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
}
