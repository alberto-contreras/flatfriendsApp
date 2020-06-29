import 'dart:convert';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:http/http.dart'as http;

SharedData sharedData = SharedData.getInstance();
class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<TaskModel> tasks = sharedData.getTasks();
  UserService userService = new UserService();
  FlatService flatService = new FlatService();

  updateTask(TaskModel task) async {
    print(task.getDone());
    await flatService.updateTask(task);
  }
  updateUserTasksStatus(UserModel value) async {
    await userService.updateUserAllTasks(value);
  }
  //This function it's going use getTime on wherever instance and then once we have the data re root to the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Tareas'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(onPressed: () async{
            await Navigator.pushNamed(context,'/regtask');
            //we put in a dynamic variable because when are doing a big async task
            //first we go to the task page and then after adding a new one we pop with a refresh
            await flatService.getTaskFlat();
            setState(() { });
          }, child: Text('Añadir Tarea'),
              shape: StadiumBorder(),
              color: Colors.red,
              textColor: Colors.white),
          FlatButton(onPressed: () async{
            await flatService.rotateTasks();
            setState(() { });
          }, child: Text('Rotar Tareas'),
              shape: StadiumBorder(),
              color: Colors.red,
              textColor: Colors.white),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top:1.0, right: 4.0, left: 4.0, bottom: 70.0),
        itemCount: tasks.length,
        itemBuilder: (context,index){ //This function will make a widget tree of the one we choose
          return Card(
            margin: const EdgeInsets.only(
              top: 16.0,
              bottom: 1.0,
              left: 24.0,
              right: 24.0,
            ),
            color: Colors.amberAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0),
            ),
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: ListTile(
                          onTap: (){
                          },//Link on press function
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(width: 1.0, color: Colors.white24))),
                            child: Icon(Icons.today, color: Colors.white, size: 30,),
                          ),
                          title: Text(tasks.elementAt(index).getTittle().toString()+' le toca a ' + sharedData.usersInFlat[tasks.elementAt(index).getIdUser().toString()],
                            style:TextStyle(fontWeight: FontWeight.bold)
                          ),
                          subtitle: Text('La tarea consiste en: ' + tasks.elementAt(index).getDescription().toString(),
                          ),
                        )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 12.0, right: 12.0),
                            child: Column(
                              children: <Widget>[
                                Text('Realizada',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  //We need to check the status of the task in order to add it to the
                                  //total number of tasks done by the user
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.green,
                                  inactiveTrackColor: Colors.red,
                                  value: tasks.elementAt(index).getDone(),
                                  onChanged: (value) => setState(() {
                                    if(tasks.elementAt(index).getDone() == true){
                                      String idUser = tasks.elementAt(index).getIdUser();
                                      if(idUser == sharedData.getUser().getIdUser()){
                                        sharedData.getUser().setAllTasks(sharedData.getUser().getAllTasks() -1);
                                        updateUserTasksStatus(sharedData.getUser());
                                      }
                                      else{
                                        for(int i =0;  i < sharedData.getTenants().length;i++){
                                          if(sharedData.getTenants().elementAt(i).getIdUser() == idUser){
                                            sharedData.getTenants().elementAt(i).setAllTasks(sharedData.getTenants().elementAt(i).getAllTasks() -1);
                                            UserModel u = new UserModel();
                                            u.setAllTasks(sharedData.getTenants().elementAt(i).getAllTasks());
                                            u.setIdUser(sharedData.getTenants().elementAt(i).getIdUser());
                                            updateUserTasksStatus(u);
                                          }
                                        }
                                      }
                                      value = !value;
                                      tasks.elementAt(index).switchDone();
                                      updateTask(tasks.elementAt(index));
                                    }
                                    else {
                                      String idUser = tasks.elementAt(index).getIdUser();
                                      if(idUser == sharedData.getUser().getIdUser()){
                                        sharedData.getUser().setAllTasks(sharedData.getUser().getAllTasks() +1);
                                        updateUserTasksStatus(sharedData.getUser());
                                      }
                                      else{
                                        for(int i =0;  i < sharedData.getTenants().length;i++){

                                          if(sharedData.getTenants().elementAt(i).getIdUser() == idUser){
                                            sharedData.getTenants().elementAt(i).setAllTasks(sharedData.getTenants().elementAt(i).getAllTasks() +1);
                                            UserModel u = new UserModel();
                                            u.setAllTasks(sharedData.getTenants().elementAt(i).getAllTasks());
                                            u.setIdUser(sharedData.getTenants().elementAt(i).getIdUser());
                                            updateUserTasksStatus(u);
                                          }
                                        }
                                      }
                                      value = !value;
                                      tasks.elementAt(index).switchDone();
                                      updateTask(tasks.elementAt(index));
                                    }
                                  }),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: () async {
                                    await flatService.deleteTask(tasks.elementAt(index));
                                    await flatService.getTaskFlat();
                                    setState(() {});
                                  },
                                  alignment: Alignment.topRight,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          );
        },
      ),
    );
  }
}
