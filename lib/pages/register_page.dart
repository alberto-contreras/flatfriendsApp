import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class Register extends StatefulWidget {
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextStyle textButtonStyle = new TextStyle(fontSize: 16);
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
            SizedBox(height: 16,),
            Text('Registro',
                textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(height: 20,),
            _textFirstname(),
            SizedBox(height: 16,),
            _textLastname(),
            SizedBox(height: 16,),
            _textUseremail(),
            SizedBox(height: 16,),
            _textPassword(),     // Creating a text field widget to get password
            SizedBox(height: 16,),
            _textRepitePassword(),
            SizedBox(height: 16,),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _registerButton(),     // Creating a button widget for Login
                SizedBox(width: 30,),
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
    return SizedBox(
        height: 45,
        width: 160,
        child: FlatButton(onPressed: () async  {
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
        child: Text('Registrar', style: textButtonStyle),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white));
  }

  Widget _cancelButton() {
    return SizedBox(
        height: 45,
        width: 160,
        child: FlatButton(onPressed: () {
      Navigator.pop(context);
    },
        child: Text('Cancelar', style: textButtonStyle,),
        shape: StadiumBorder(),
        color: Colors.red,
        textColor: Colors.white));
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
