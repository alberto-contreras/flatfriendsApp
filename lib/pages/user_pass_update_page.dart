import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class UserUpdatePassword extends StatefulWidget {
  _UserUpdatePassword createState() => _UserUpdatePassword();
}

class _UserUpdatePassword extends State<UserUpdatePassword> {
  final TextStyle textButtonStyle = new TextStyle(fontSize: 16);
  SharedData sharedData = SharedData.getInstance();
  TextEditingController actualPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController repiteNewPasswordController = new TextEditingController();
  UserService userService = new UserService();
  UserModel userToUpdate = new UserModel();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16,),
                Text('Cambiar contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 30,),
                _textActualPassword(),
                SizedBox(height: 16,),
                _textNewPassword(),
                SizedBox(height: 16,),
                _textNewRepitePassword(), // Creating a text field widget to get password
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _updateButton(), // Creating a button widget for Login
                    SizedBox(width: 30,),
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
      ),
    );
  }

  Widget _updateButton() {
    return SizedBox(
      height: 45,
      width: 160,
      child: FlatButton(onPressed: () async  {
        print('Dentro Update Usuario');
        if(newPasswordController.text == repiteNewPasswordController.text && actualPasswordController.text == sharedData.getUser().getPassword()) {
          userToUpdate = this.sharedData.infoUser;
          userToUpdate.setPassword(newPasswordController.text);
          int res = await userService.updateUser(this.userToUpdate);
          if( res == 0){
            Navigator.pop(context);
            showToast('.Contraseña cambiada correctamente',
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
            //Error cambiando la contraseña
            //Alert password or email incorrect
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return _alertNotPossibleChangePassword();
                });
          }
        }
        else {
          //Password not well introduced
          _alertWrongFields();
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

  Widget _alertNotPossibleChangePassword() {
    return PlatformAlertDialog(
      title: Text('Error'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('No ha sido posible cambiar la contraseña.'),
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

  Widget _alertWrongFields() {
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
                    child: Text(
                        'Ha habido un error. Revisa los campos de texto.', style: TextStyle(fontSize: 16),),
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
