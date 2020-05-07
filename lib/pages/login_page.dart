import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flatfriendsapp/services/GoogleAuth.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController useremailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  UserModel userLogin = new UserModel();
  UserService userService = new UserService();
  Oauth2ClientExample googleAuth = new Oauth2ClientExample();


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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _textUseremail(),
            Divider(),
            _textPassword(),
            Divider(),
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
        ),
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

  Widget _loginButton() {
    return FlatButton(onPressed: () async {
      print('Dentro Login');
        userLogin.setEmail(useremailController.text);
        userLogin.setPassword(passwordController.text);
        int res = await userService.logUser(this.userLogin);
        print(res);
        if( res == 0){

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
        child: Text('Login'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _registerButton() {
    return FlatButton(onPressed: () {
      Navigator.pushNamed(context, '/register');
    },
        child: Text('Register'),
        shape: StadiumBorder(),
        color: Colors.blue,
        textColor: Colors.white);
  }

  Widget _registerGoogleButton() {

    return FlatButton(onPressed: () async {
      int answer = await googleAuth.fetchFiles();
      if(answer == 0){
        Navigator.pushReplacementNamed(context, '/home');
      }
      else{
        print('POPUP BAD REQUEST GOOGLE');
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertLoginGoogle();
            });

      }
    }, child: Text('Sing in w/ Google'));

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

