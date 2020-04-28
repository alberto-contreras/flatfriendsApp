import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  _UpdateUser createState() => _UpdateUser();
}

class _UpdateUser extends State<UpdateUser> {
  SharedData sharedData = SharedData.getInstance();
  TextEditingController actualPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController repiteNewPasswordController = new TextEditingController();
  UserService userService = new UserService();
  UserModel userToUpdate = new UserModel();

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
            Text('Cambiar contraseña:',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Divider(),
            _textActualPassword(),
            Divider(),
            _textNewPassword(),
            Divider(),
            _textNewRepitePassword(), // Creating a text field widget to get password
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _updateButton(), // Creating a button widget for Login
                SizedBox(width: 60,),
                _cancelButton()
              ],
            ), // Creating a button widget for Register
          ],
        ),
      ),
    );
  }

  Widget _textActualPassword() {
    return TextField(
      controller: actualPasswordController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Contraseña actual',
          hintText: 'Escribe tu contraseña actual',
          suffixIcon: Icon(Icons.beenhere, color: Colors.blue),
          icon: Icon(Icons.lock)
      ),
    );
  }

  Widget _textNewPassword() {
    return TextField(
      controller: newPasswordController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Nueva contraseña',
          hintText: 'Escrbir tu nueva contraseña.',
          suffixIcon: Icon(Icons.lock_open, color: Colors.blue),
          icon: Icon(Icons.lock)
      ),
    );
  }

  Widget _textNewRepitePassword() {
    return TextField(
      controller: repiteNewPasswordController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Repetir la nueva contraseña',
          hintText: 'Repite tu nueva contraseña',
          suffixIcon: Icon(Icons.beenhere, color: Colors.blue),
          icon: Icon(Icons.lock)
      ),
    );
  }

  Widget _updateButton() {
    return FlatButton(onPressed: () async  {
      print('Dentro Update Usuario');
      if(newPasswordController.text == repiteNewPasswordController.text && actualPasswordController.text == sharedData.getUser().getPassword()) {
        userToUpdate = this.sharedData.infoUser;
        userToUpdate.setPassword(newPasswordController.text);
        int res = await userService.updateUser(this.userToUpdate);
        if( res == 0){
          Navigator.pop(context);
        }
        else{
          print('Error en el registro, vuelve a intentarlo');
        }
      }
      else {
        print('Contraseñas mal introducidas.');
      }
    },
        child: Text('Actualizar'),
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
}
