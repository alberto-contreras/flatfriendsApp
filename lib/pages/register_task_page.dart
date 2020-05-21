import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Task.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

SharedData sharedData = SharedData.getInstance();
class RegisterTask extends StatefulWidget {
  @override
  _RegisterTaskState createState() => _RegisterTaskState();
}

class _RegisterTaskState extends State<RegisterTask> {
  TextEditingController tittleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController idUserController = new TextEditingController();
  FlatService flatService = new FlatService();
  TaskModel taskToAdd = new TaskModel();
  List<DropdownMenuItem<String>> listDrop = [];
  String dropdownValue;


  void loadFlatUsers() {
    listDrop = [];
    for (num i=0; i<sharedData.getUsersInFlat().length; i++) {
      print('Name: ' + sharedData.getUsersInFlat()[i][1]);
      print('id: ' + sharedData.getUsersInFlat()[i][0]);
      listDrop.add(new DropdownMenuItem(
        child: new Text(sharedData.getUsersInFlat()[i][1]),
        value: sharedData.getUsersInFlat()[i][0],
      ));
    }
  }

  void updateTime() async
  {
    Navigator.pop(context);
  }

  void initState() {
    super.initState();
    loadFlatUsers();
    dropdownValue = listDrop[0].value;
    print(dropdownValue);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks of your Flat'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Añadir Tarea',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Divider(),
            _textTittle(),
            Divider(),
            _textDescription(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Encargado: '),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: listDrop,
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _registerTaskButton(),     // Creating a button widget for Login
                SizedBox(width: 60,),
                _cancelButton()
              ],
            ), // Creating a button widget for Register
          ],
        ),
      ),
    );
  }

  Widget _textTittle(){
    return TextField(
      controller: tittleController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Escribe el nombre de la tarea',
          icon: Icon(Icons.play_arrow)
      ),
    );
  }

  Widget _textDescription(){
    return TextField(
      controller: descriptionController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Describelo',
          icon: Icon(Icons.description)
      ),
    );
  }

  Widget _textIdUser() {
    return TextField(
      controller: idUserController,
      obscureText: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Asignar a un usuario.',
          icon: Icon(Icons.date_range)
      ),
    );
  }

  Widget _registerTaskButton() {
    return FlatButton(onPressed: () async  {
      print('Dentro Registro Tarea');
      taskToAdd.setIdPiso(sharedData.getUser().getIdPiso());
      taskToAdd.setTittle(tittleController.text);
      taskToAdd.setDescription(descriptionController.text);
      taskToAdd.setIdUser(dropdownValue);
      taskToAdd.setDone(false);
      int res = await flatService.addTaskFlat(this.taskToAdd);
      print(res);
      if( res == 0){
        Navigator.pop(context);
      }
      else{
        //Alert error adding the user
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertRegisterTask();
            });
      }

    },
        child: Text('Añadir Tarea'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _cancelButton() {
    return FlatButton(onPressed: () {
      Navigator.pop(context);
    },
        child: Text('Cancel'),
        shape: StadiumBorder(),
        color: Colors.red,
        textColor: Colors.white);
  }

  Widget _alertRegisterTask(){
    return PlatformAlertDialog(
      title: Text('Hey!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Error en el registro vuelve a intentarlo.'),
            Text('Ayuda: Revisa los datos.'),
          ],
        ),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text('Aceptar'),
          onPressed: () async {
            //Navigator.of(context).pop();
            flatService.getTaskFlat();
            updateTime();
          },
        ),
      ],
    );
  }
}


