
import 'dart:io';

import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/pages/user_attributes_update.dart';
import 'package:flatfriendsapp/pages/user_pass_update_page.dart';
import 'package:flatfriendsapp/services/GoogleAuth.dart';
import 'package:flatfriendsapp/transitions/horizontal_transition_left_to_right.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:slider_button/slider_button.dart';
//import 'package:slider_button/slider_button.dart';

class UserSettings extends StatefulWidget {
  _UserSettings createState() => _UserSettings();
}
SharedData sharedData = SharedData.getInstance();

class _UserSettings extends State<UserSettings> {
  TextEditingController passwordController = new TextEditingController();
  final TextStyle textButtonStyle = new TextStyle(fontSize: 16);
  static const TextStyle titlesStyle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, );
  static const TextStyle subTitlesStyle = TextStyle(
    fontSize: 15, fontStyle: FontStyle.italic, );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes de usuario'),
      ),
      body: _options(context),
    );
  }

  Widget _options(var context) => ListView(
    children: [
      ListTile(
        title: Text('Actualizar contraseña', style: titlesStyle,),
        subtitle: Text('Accede para cambiar tu contraseña de usuario.', style: subTitlesStyle,),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        onTap: () {
          Navigator.push(context, EnterRightExitLeftRoute(exitPage: UserSettings(), enterPage: UserUpdatePassword()));
        },
      ),
      ListTile(
        title: Text('Actualizar datos de usuario', style: titlesStyle,),
        subtitle: Text('Accede para actualizar tu correo, teléfono o tu foto de perfil.', style: subTitlesStyle),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        onTap: () {
          Navigator.push(context, EnterRightExitLeftRoute(exitPage: UserSettings(), enterPage: UserUpdateAttributes()));
        },
      ),
      ListTile(
        title: Text('Eliminar usuario', style: titlesStyle,),
        subtitle: Text('Eliminar tu cuenta de usuario de Flat&Friends.', style: subTitlesStyle),
        trailing: Icon(Icons.cancel, color: Colors.red),
        onTap: () {
          _onDeleteAccountAlert();
        },
      ),
      if (sharedData.getFlat() != null) ListTile(
        title: Text('Abandonar piso', style: titlesStyle,),
        subtitle: Text('Accede para salir de tu piso actual.', style: subTitlesStyle),
        trailing: Icon(Icons.business, color: Colors.red),
        onTap: () {
         _onRemoveFromFlatAlert();
        },
      ),
    ],
  );

  Widget _onDeleteAccountAlert() {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            title: Text('¡Atención!'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tu cuenta y todos tus datos serán eliminados de nuestra base de datos de forma defintiva.',
                      style: TextStyle(fontSize: 17),),
                    SizedBox(height: 16,),
                    SizedBox(
                      height: 70,
                      width: 250,
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          labelText: 'Contraseña',
                          hintText: 'Escrbir una contraseña.',
                          suffixIcon: Icon(Icons.lock_open, color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    SliderButton(
                      action: () async {
                        if (passwordController.text == sharedData.getUser().getPassword() || sharedData.getUser().getGoogleAuth() == true){
                          Navigator.pop(context);
                          int res;
                          if (sharedData.getFlat() != null) {
                            res = await flatService.removeTenant(
                                sharedData.getUser().getIdUser(),
                                sharedData.getFlat().getID());
                          }
                          res = await userService.deleteUser();
                          print('Esto es lo que hay al querer borrar usuario' + res.toString());
                          if (res == 0){
                            _goodByePopUp();
                          }
                          else{
                            showToast('.Inténtalo de nuevo más tarde',
                                context: context,
                                textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                                backgroundColor: Colors.blue[900],
                                textPadding:
                                EdgeInsets.symmetric(vertical: 15, horizontal: 30.0),
                                borderRadius: BorderRadius.circular(15),
                                textAlign: TextAlign.justify,
                                textDirection: TextDirection.rtl);
                          }
                        }
                        else{
                          Navigator.pop(context);
                          showToast('.Contraseña incorrecta ',
                              context: context,
                              textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                              backgroundColor: Colors.redAccent,
                              textPadding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 30.0),
                              borderRadius: BorderRadius.circular(15),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl);
                        }
                        passwordController.clear();
                      },
                      label: Text(
                        "Desliza para eliminar tu cuenta",
                        style: TextStyle(
                            color: Color(0xff4a4a4a),
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      icon: Icon(Icons.cancel, color: Colors.red, size: 50,),
                      buttonColor: Colors.white,
                      height: 50,
                      buttonSize: 50,
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      height: 45,
                      width: 160,
                      child: FlatButton(onPressed: () {
                        passwordController.clear();
                        Navigator.pop(context);
                      },
                          child: Text('Cancelar', style: textButtonStyle),
                          shape: StadiumBorder(),
                          color: Colors.blue[900],
                          textColor: Colors.white),
                    ),

                  ],
                ),
              )

            ],
          );
      },
    );
  }

  Widget _goodByePopUp() {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            title: Text('¡Hasta pronto!'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Gracias por haber usado Flat&Friends.',
                      style: TextStyle(fontSize: 17),),
                    SizedBox(height: 10,),
                    Text(
                      'Recuerda que puedes volver a registrarte cuando quieras.',
                      style: TextStyle(fontSize: 17),),
                    SizedBox(height: 16,),
                    SizedBox(
                      height: 45,
                      width: 160,
                      child: FlatButton(onPressed: () {
                        sharedData.clear();
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (Route<dynamic> route) => false);
                        });
                      },
                          child: Text('Aceptar', style: textButtonStyle),
                          shape: StadiumBorder(),
                          color: Colors.blue[900],
                          textColor: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _onRemoveFromFlatAlert() {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          title: Text('¡Atención!'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¿Quieres salir del piso en el que estás?',
                    style: TextStyle(fontSize: 17),),
                  SizedBox(height: 16,),
                  SliderButton(
                    action: () async {
                      Navigator.pop(context);
                      int res = await flatService.removeTenant(sharedData.getUser().getIdUser(), sharedData.getFlat().getID());
                      if (res == 0){
                        setState(() {
                          sharedData.clearFlat();
                        });
                        showToast('.Has salido del piso: ' + sharedData.getFlat().getName(),
                            context: context,
                            textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                            backgroundColor: Colors.deepPurple,
                            textPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30.0),
                            borderRadius: BorderRadius.circular(15),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl);
                      }
                    },
                    label: Text(
                      "Desliza para salir del piso",
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    icon: Icon(Icons.cancel, color: Colors.red, size: 50,),
                    buttonColor: Colors.white,
                    height: 50,
                    buttonSize: 50,

                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    height: 45,
                    width: 160,
                    child: FlatButton(onPressed: () {
                      Navigator.pop(context);
                    },
                        child: Text('Cancelar', style: textButtonStyle),
                        shape: StadiumBorder(),
                        color: Colors.blue[900],
                        textColor: Colors.white),
                  ),

                ],
              ),
            )

          ],
        );
      },
    );
  }


}
