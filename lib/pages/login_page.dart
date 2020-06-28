import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flatfriendsapp/services/GoogleAuth.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController useremailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  UserModel userLogin = new UserModel();
  UserService userService = new UserService();
  Oauth2ClientExample googleAuth = new Oauth2ClientExample();
  SharedData sharedData = SharedData.getInstance();
  static const TextStyle tilesStyle = TextStyle(
    fontSize: 40, fontWeight: FontWeight.bold, );


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
        child: SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SizedBox(height: 50,),
        Image.asset('graphics/logo.png'),
        SizedBox(height: 20,),
        ColorizeAnimatedTextKit(
            text: [
              "Flat & Friends",
            ],
            textStyle: tilesStyle,
            colors: [
              Colors.purple,
              Colors.blue,
              Colors.purple,
              Colors.blue,
            ],
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        ),
        SizedBox(height: 80,),
        _textUseremail(),
        SizedBox(height: 16,),
        _textPassword(),
        SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loginButton(),     // Creating a button widget for Login
            SizedBox(width: 60,),
            _registerButton()
          ],
        ),
        SizedBox(height: 10,),
        _registerGoogleButton(),
      ],
    )
        ),
    )
    );
  }

  Widget _textUseremail(){
    return TextField(
      controller: useremailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Correo electrónico',
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

  Widget _loginButton() {
    return FlatButton(onPressed: () async {
      print('Dentro Login');
        userLogin.setEmail(useremailController.text);
        userLogin.setPassword(passwordController.text);
        int res = await userService.logUser(this.userLogin);
        if( res == 0){
          if (sharedData.getUser().getIdPiso() != null && sharedData.getUser().getIdPiso().length == 24) {
            print('antes de llamar initChatService');
            if (sharedData.getIdChatRoom() != sharedData.getUser().getIdPiso()) {
             sharedData.setChatRoomStatus(false);
              print('PISO DIFERENTEEEE, LOGINNNN');
            }
            if (sharedData.getChatRoomStatus() == false){
              await sharedData.chatService.initChatService(
                  sharedData.getUser().getIdPiso());
//              sharedData.chatService.onMessage();
            }
            sharedData.chatRunning = true;
              int getFlat = await flatService.getFlat();
              int getTenants = await flatService.getTenantsFlat();
              if (getFlat == 0 && getFlat == getTenants ) {
                print('Success getting Flat Data and Tenants Data through Flat&Friends Logging In.');
              }
          }
          Navigator.pushReplacementNamed(context, '/home');
        }
        else{
          //Alert password or email incorrect
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
              return _alertLogin();
              });
        }
    },
        child: Text('Iniciar Sesión'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _registerButton() {
    return FlatButton(onPressed: () {
      Navigator.pushNamed(context, '/register');
    },
        child: Text('Registrarse'),
        shape: StadiumBorder(),
        color: Colors.blue,
        textColor: Colors.white);
  }

  Widget _registerGoogleButton() {
    return GoogleSignInButton(onPressed: () async {
      int answer = await googleAuth.fetchFiles();
      if (answer == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      else {
        print('POPUP BAD REQUEST GOOGLE');
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertLoginGoogle();
            });
      }
    },
      splashColor: Colors.transparent,
    );
  }

   Widget _alertLogin(){
     return PlatformAlertDialog(
       title: Text('Hey!'),
       content: SingleChildScrollView(
         child: ListBody(
           children: <Widget>[
             Text('El correo o la contraseña son incorrectos.'),
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

  Widget _alertLoginGoogle(){
    return PlatformAlertDialog(
      title: Text('Hey!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Problemas con Google.'),
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

