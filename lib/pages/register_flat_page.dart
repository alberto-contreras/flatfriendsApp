import 'package:flatfriendsapp/models/Flat.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class RegisterFlat extends StatefulWidget {
  _RegisterFlat createState() => _RegisterFlat();
}

class _RegisterFlat extends State<RegisterFlat> {
  TextEditingController flatNameController = new TextEditingController();
  TextEditingController flatDescriptionController = new TextEditingController();
  TextEditingController maxPersonsController = new TextEditingController();
  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  FlatModel flat = new FlatModel();
  FlatService flatService = new FlatService();
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle labelStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flat & Friends'),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Text('Registrar un nuevo piso:', style: optionStyle),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Datos del piso:', style: labelStyle),
                SizedBox(height: 10,),
                _textFlatname(),
                Divider(),
                _textFlatDescription(),
                Divider(),
                _textMaxPersons(),
                SizedBox(height: 30,),
                Text('Localización del piso:', style: labelStyle),
                SizedBox(height: 10,),
                _textLatitude(),
                Divider(),
                _textLongitude(),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _registerButton(), // Creating a button widget for Login
                    SizedBox(width: 60,),
                    _cancelButton()
                  ],
                ),
              ],
            ),
          ),
          ],
        ),
    );
  }

  Widget _textFlatname(){
    return TextField(
      controller: flatNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Nombre del piso',
          hintText: 'Escribe el nombre del piso',
          suffixIcon: Icon(Icons.home, color: Colors.blue),
          icon: Icon(Icons.business)
      ),
    );
  }

  Widget _textFlatDescription(){
    return TextField(
      controller: flatDescriptionController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Descripción del piso',
          hintText: 'Escribe si quieres una descripción',
          suffixIcon: Icon(Icons.assignment, color: Colors.blue),
          icon: Icon(Icons.assignment)
      ),
    );
  }

  Widget _textMaxPersons(){
    return TextField(
      controller: maxPersonsController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Número máximo de inquilinos',
          hintText: 'Indica la cantidad máxima de inquilinos',
          suffixIcon: Icon(Icons.assignment, color: Colors.blue),
          icon: Icon(Icons.assignment)
      ),
    );
  }

  Widget _textLatitude(){
    return TextField(
      controller: latitudeController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Longitud',
          hintText: 'Escribe la longitud',
          suffixIcon: Icon(Icons.assignment, color: Colors.blue),
          icon: Icon(Icons.assignment)
      ),
    );
  }

  Widget _textLongitude(){
    return TextField(
      controller: longitudeController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Latitud',
          hintText: 'Escribe la latitud',
          suffixIcon: Icon(Icons.assignment, color: Colors.blue),
          icon: Icon(Icons.assignment)
      ),
    );
  }

  Widget _registerButton() {
    return FlatButton(onPressed: () async {
      print('Dentro Registro de piso');
      if (flatNameController.text != '' && maxPersonsController.text != '' &&
      latitudeController.text != '' && longitudeController.text != '') {
        flat.setName(flatNameController.text);
        flat.setDescription(flatDescriptionController.text);
        flat.setFull(false);
        flat.setMaxPersons(int.parse(maxPersonsController.text));
        flat.setLocation(latitudeController.text, longitudeController.text);
        print("latitude: " + flat.getLocation().getLatitude() + ", longitude: " + flat.getLocation().getLongitude());
        int res = await flatService.registerFlat(flat);
        print(res);
        if (res == 0) {

          await sharedData.chatService.initChatService(sharedData.getUser().getIdPiso());
          sharedData.chatService.onMessage();
          sharedData.chatRunning = true;
          Navigator.pop(context, () {
            setState(() {});
          });
        }
        else {
          //Error adding new flat
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return _alertRegisterFlat();
              });
        }
      }
      else{
        //Empty fields
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertEmptyFields();
            });
      }
    },
        child: Text('Registrar piso'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _cancelButton() {
    return FlatButton(onPressed: () {
      Navigator.pop(context);
    },
        child: Text('Cancelar'),
        shape: StadiumBorder(),
        color: Colors.red,
        textColor: Colors.white);
  }

  Widget _alertRegisterFlat() {
    return PlatformAlertDialog(
      title: Text('Error'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Error en el registro vuelve a intentarlo.'),
            Text('Ayuda: Revisa los datos del piso.'),
          ],
        ),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

    Widget _alertEmptyFields() {
      return PlatformAlertDialog(
        title: Text('Hey!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Error en el registro vuelve a intentarlo.'),
              Text('Ayuda: Revisa los datos del piso.'),
            ],
          ),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
}
