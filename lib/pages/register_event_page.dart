import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Event.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

SharedData sharedData = SharedData.getInstance();
class RegisterEvent extends StatefulWidget {
  @override
  _RegisterEventState createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController organizerController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  FlatService flatService = new FlatService();
  EventModel eventToAdd = new EventModel();
  var date;
  var time;
  var dateEvent;

  void updateTime() async
  {
    Navigator.pop(context);
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events of your Flat'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Añadir Evento',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Divider(),
            _textName(),
            Divider(),
            _textDescription(),
            Divider(),
            _textDate(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _registerEventButton(),     // Creating a button widget for Login
                SizedBox(width: 60,),
                _cancelButton()
              ],
            ), // Creating a button widget for Register
          ],
        ),
      ),
    );
  }

  Widget _textName(){
    return TextField(
      controller: nameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Escribe el nombre del evento',
          icon: Icon(Icons.play_arrow)
      ),
    );
  }

  Widget _textDescription(){
    return TextField(
      controller: descriptionController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Describelo',
          icon: Icon(Icons.description)
      ),
    );
  }

  Widget _textDate() {
    final format = DateFormat("yyyy-MM-dd HH:mm");
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'Introduce una fecha.',
            icon: Icon(Icons.date_range)
        ),
        onShowPicker: (context, currentValue) async {
          date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            time = await showTimePicker(
              context: context,
              initialTime:
              TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return dateEvent = DateTimeField.combine(date, time);
          } else {
            return currentValue;

          }
        },
      ),
    ]);
  }

  Widget _registerEventButton() {
    return FlatButton(onPressed: () async  {
      print('Dentro Registro Evento');
      if(descriptionController.text == null || nameController.text == null || dateEvent == null){
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertRegisterEvent();
            });
      }
      else {
        eventToAdd.setIdPiso(sharedData.getUser().getIdPiso());
        eventToAdd.setName(nameController.text);
        eventToAdd.setDescription(descriptionController.text);
        eventToAdd.setOrganizer(sharedData.getUser().getFirstname());
        eventToAdd.setDate(dateEvent.toString());
        for (int i = 0; i < sharedData
            .getUsersInFlatForEvent()
            .length; i++) { //We Set the State of the user that creates the event to 1 (accepted)
          if (sharedData.getUsersInFlatForEvent().elementAt(i).getId() ==
              sharedData.getUser().getIdUser()) {
            sharedData.getUsersInFlatForEvent().elementAt(i).setStatus('1');
          }
          eventToAdd.setUsers(sharedData.getUsersInFlatForEvent());
          print('evento antes de enviar');
        }
        int res = await flatService.addEventFlat(this.eventToAdd);
        print(res);
        if (res == 0) {
          Navigator.pop(context);
        }
        else {
          //Alert error adding the user
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return _alertRegisterEvent();
              });
        }
      }

    },
        child: Text('Añadir Evento'),
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

  Widget _alertRegisterEvent(){
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
            flatService.getEventFlat();
            updateTime();
          },
        ),
      ],
    );
  }

}


