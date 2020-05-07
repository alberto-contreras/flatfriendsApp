import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class Register extends StatefulWidget {
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController useremailController = new TextEditingController();
  TextEditingController flatIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repitePasswordController = new TextEditingController();
  UserService userService = new UserService();
  UserModel userToAdd = new UserModel();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Registro',
                textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Divider(),
            _textFirstname(),
            Divider(),
            _textLastname(),
            Divider(),
            _textUseremail(),
            Divider(),
            _textPassword(),     // Creating a text field widget to get password
            Divider(),
            _textRepitePassword(),
            Divider(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _registerButton(),     // Creating a button widget for Login
                SizedBox(width: 60,),
                _cancelButton()
              ],
            ), // Creating a button widget for Register
          ],
        ),
      ),
    );
  }

  Widget _textFirstname(){
    return TextField(
      controller: firstnameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Nombre',
          hintText: 'Escribe tu nombre',
          suffixIcon: Icon(Icons.person_pin, color: Colors.blue),
          icon: Icon(Icons.person)
      ),
    );
  }

  Widget _textLastname(){
    return TextField(
      controller: lastnameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Apellido',
          hintText: 'Escribe tu apellido',
          suffixIcon: Icon(Icons.person_pin, color: Colors.blue),
          icon: Icon(Icons.person)
      ),
    );
  }

  Widget _textUseremail(){
    return TextField(
      controller: useremailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Correo electónico',
          hintText: 'Escribe tu correo electrónico',
          suffixIcon: Icon(Icons.alternate_email, color: Colors.blue),
          icon: Icon(Icons.email)
      ),
    );
  }

  Widget _textPassword() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Contraseña',
          hintText: 'Escrbir una contraseña.',
          suffixIcon: Icon(Icons.lock_open, color: Colors.blue),
          icon: Icon(Icons.lock)
      ),
    );
  }

  Widget _textRepitePassword() {
    return TextField(
      controller: repitePasswordController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Repetir contraseña',
          hintText: 'Repite la contraseña',
          suffixIcon: Icon(Icons.beenhere, color: Colors.blue),
          icon: Icon(Icons.lock)
      ),
    );
  }

  Widget _registerButton() {
    return FlatButton(onPressed: () async  {
      print('Dentro Registro');
      if(passwordController.text == repitePasswordController.text) {
        userToAdd.setFirstname(firstnameController.text);
        userToAdd.setLastname(lastnameController.text);
        userToAdd.setEmail(useremailController.text);
        userToAdd.setPassword(passwordController.text);
        userToAdd.setGoogleAuth(false);
        int res = await userService.registerUser(this.userToAdd);
        if( res == 0){
          Navigator.pop(context);
        }
        else{
          //Alert error adding the user
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return _alertRegisterUser();
              });
        }
      }
    },
        child: Text('Register'),
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
  Widget _alertRegisterUser(){
    return PlatformAlertDialog(
      title: Text('Hey!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Error en el registro vuelve a intentarlo.'),
            Text('Ayuda: Revisa el email.'),
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
