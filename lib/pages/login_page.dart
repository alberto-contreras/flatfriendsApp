import 'package:flatfriendsapp/models/user.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController useremailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  UserModel userLogin = new UserModel();
  UserService userService = new UserService();

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
          print('Error en el login, vuelve a intentarlo');
        }
    },
        child: Text('Login'),
        shape: StadiumBorder(),
        color: Colors.blue,
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



}
