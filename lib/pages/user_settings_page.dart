
import 'package:flatfriendsapp/pages/user_attributes_update.dart';
import 'package:flatfriendsapp/pages/user_pass_update_page.dart';
import 'package:flatfriendsapp/transitions/horizontal_transition_left_to_right.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  _UserSettings createState() => _UserSettings();
}

class _UserSettings extends State<UserSettings> {
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
        title: Text('Abandonar piso', style: titlesStyle,),
        subtitle: Text('Accede para salir de tu piso actual.', style: subTitlesStyle),
        trailing: Icon(Icons.business, color: Colors.blue),
        onTap: () {
          // Hacer saltar un dialog
        },
      ),

    ],
  );
}
