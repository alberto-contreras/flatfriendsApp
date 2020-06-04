import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class FlatUpdateAttributes extends StatefulWidget {
  @override
  _FlatUpdateAttributesState createState() => _FlatUpdateAttributesState();
}

class _FlatUpdateAttributesState extends State<FlatUpdateAttributes> {
  final TextStyle textButtonStyle = new TextStyle(fontSize: 16);
  SharedData sharedData = SharedData.getInstance();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController maxPersonsController = new TextEditingController();
  FlatService flatService = new FlatService();
  FlatModel flatToUpdate = new FlatModel();
  bool nameGoingUpdate = false;
  bool descriptionGoingUpdate = false;
  bool maxPersonsGoingUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16,),
                Text('Actualizar datos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 30,),
                _newNameTextField(),
                SizedBox(height: 16,),
                _newDescriptionTextField(),
                SizedBox(height: 16,),
                _newMaxPersonsTextField(),
                SizedBox(height: 16,),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _updateButton(), // Creating a button widget for Login
                    SizedBox(width: 30,),
                    _cancelButton()
                  ],
                ),
                // Creating a button widget for Register
              ],
            ),
          ),
        )

    );
  }

  Widget _newNameTextField() =>
      TextField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: sharedData.getFlat().getName(),
          hintText: 'Escribe el nuevo nombre del piso',
          icon: Icon(Icons.assignment),
        ),
      );

  Widget _newDescriptionTextField() =>
      TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: sharedData.getFlat().getDescription(),
          hintText: 'Escribe la nueva descripción del piso',
          icon: Icon(Icons.assignment),
        ),
      );

  Widget _newMaxPersonsTextField() =>
      TextField(
        controller: maxPersonsController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: sharedData.getFlat().getMaxPersons().toString(),
          hintText: 'Escribe el número máximo de inquilinos.',
          icon: Icon(Icons.people),
        ),
      );

  Widget _updateButton() {
    return SizedBox(
        height: 45,
        width: 160,
        child: FlatButton(onPressed: () async  {
          flatToUpdate.setName(sharedData.getFlat().getName());
          flatToUpdate.setDescription(sharedData.getFlat().getDescription());
          flatToUpdate.setMaxPersons(sharedData.getFlat().getMaxPersons());
          if (nameController.text.length > 0){
            flatToUpdate.setName(nameController.text);
            nameGoingUpdate = true;
          }
          if (descriptionController.text.length > 0){
            flatToUpdate.setDescription(descriptionController.text);
            descriptionGoingUpdate = true;
          }
          if (maxPersonsController.text.length > 0){
            int maxPersons = int.parse(maxPersonsController.text);
            if (maxPersons >= sharedData.getFlat().getNumPersons()) {
              flatToUpdate.setMaxPersons(maxPersons);
            }
            maxPersonsGoingUpdate = true;
          }
          print('Dentro Update Flat: ' + nameGoingUpdate.toString() + descriptionGoingUpdate.toString() + maxPersonsGoingUpdate.toString());
          if (nameGoingUpdate || descriptionGoingUpdate || maxPersonsGoingUpdate){
            int res = await flatService.updateFlat(this.flatToUpdate);
            if( res == 0){
              sharedData.getFlat().setName(flatToUpdate.getName());
              sharedData.getFlat().setDescription(flatToUpdate.getDescription());
              sharedData.getFlat().setMaxPersons(flatToUpdate.getMaxPersons());
              Navigator.pop(context);
              showToast('.Datos actualizados correctamente',
                  context: context,
                  textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  backgroundColor: Colors.deepPurple,
                  textPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 30.0),
                  borderRadius: BorderRadius.circular(15),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl);
            }
            else{
              print('Error al actualizar piso');
            }
          }
          else {
            _alertError();
          }
        },
            child: Text('Actualizar', style: textButtonStyle,),
            shape: StadiumBorder(),
            color: Colors.green,
            textColor: Colors.white)

    );
  }

  Widget _cancelButton() {
    return SizedBox(
      height: 45,
      width: 160,
      child: FlatButton(onPressed: () {
        Navigator.pop(context);
      },
          child: Text('Cancelar', style: textButtonStyle),
          shape: StadiumBorder(),
          color: Colors.red,
          textColor: Colors.white),
    );
  }

  Widget _alertError() {
    showDialog(context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            title: Text('¡Hey!'),
            actions: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text('No has rellenado ningún campo.', style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 20,),
                  FlatButton(
                    child: Text('Aceptar'),
                    shape: StadiumBorder(),
                    color: Colors.blue[900],
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ],
          );
        }
    );
  }

}
