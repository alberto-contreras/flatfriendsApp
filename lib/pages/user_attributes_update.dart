import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class UserUpdateAttributes extends StatefulWidget {
  @override
  _UserUpdateAttributesState createState() => _UserUpdateAttributesState();
}

class _UserUpdateAttributesState extends State<UserUpdateAttributes> {
  final TextStyle textButtonStyle = new TextStyle(fontSize: 16);
  SharedData sharedData = SharedData.getInstance();
  TextEditingController repeatEmailController = new TextEditingController();
  TextEditingController newEmailController = new TextEditingController();
  TextEditingController newPhoneController = new TextEditingController();
  TextEditingController newAvatarController = new TextEditingController();
  UserService userService = new UserService();
  UserModel userToUpdate = new UserModel();
  bool emailGoingUpdate = false;
  bool phoneNumberGoingUpdate = false;
  bool avatarGoingUpdate = false;

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
              _newEmailTextField(),
              SizedBox(height: 16,),
              _newEmailRepeatTextField(),
              SizedBox(height: 16,),
              _newPhoneTextField(),
              SizedBox(height: 16,),
              Row(
                children: [
                  _userAvatar(),
                  SizedBox(width: 1,),
                  Flexible(
                    child: _newProfilePhotoTextField(),
                  )
                ],
              ),


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

  Widget _newEmailTextField() =>
      TextField(
        controller: newEmailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: sharedData.getUser().getEmail(),
          hintText: 'Escribe tu nueva dirección de correo',
            icon: Icon(Icons.alternate_email),
        ),
      );

  Widget _newEmailRepeatTextField() =>
      TextField(
        controller: repeatEmailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Repite tu nueva dirección de correo',
          hintText: 'Nueva dirección de correo',
          icon: Icon(Icons.alternate_email),
        ),
      );

  Widget _newPhoneTextField() =>
      TextField(
        controller: newPhoneController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: sharedData.getUser().getPhoneNumber(),
          hintText: 'Escribe tu nuevo número de teléfono.',
          icon: Icon(Icons.phone),
        ),
      );

  Widget _newProfilePhotoTextField() =>
      TextField(
        controller: newAvatarController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Actualiza tu avatar',
          hintText: 'Introduce la URL de tu nuevo avatar',
        ),
      );

  Widget _userAvatar() {
    if (sharedData.getUser().getUrlAvatar() == null) {
      return CircleAvatar(
        radius: 20,
        child: Text(sharedData.getUser().getFirstname()[0] + sharedData.getUser().getLastname()[0]),
      );
  }
    else{
      return CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(sharedData.getUser().getUrlAvatar()));
    }
  }

  Widget _updateButton() {
    return SizedBox(
        height: 45,
        width: 160,
        child: FlatButton(onPressed: () async  {
          userToUpdate = sharedData.getUser();
          if (newEmailController.text == repeatEmailController.text && newEmailController.text.length > 0){
            userToUpdate.setEmail(newEmailController.text);
            emailGoingUpdate = true;
          }
          if (newPhoneController.text.length > 0){
            userToUpdate.setPhoneNumber(newPhoneController.text);
            phoneNumberGoingUpdate = true;
          }
          if (newAvatarController.text.length > 0){
            userToUpdate.setUrlAvatar(newAvatarController.text);
            avatarGoingUpdate = true;
          }
          print('Dentro Update Usuario: ' + avatarGoingUpdate.toString() + phoneNumberGoingUpdate.toString() + emailGoingUpdate.toString());
          if (emailGoingUpdate || phoneNumberGoingUpdate || avatarGoingUpdate){
            int res = await userService.updateUser(this.userToUpdate);
            if( res == 0){
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
                    child: Text('No has rellenado ningún campo o has introducido mal el correo electrónico.', style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
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
