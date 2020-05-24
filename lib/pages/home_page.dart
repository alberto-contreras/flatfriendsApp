import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

SharedData sharedData = SharedData.getInstance();

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController idFlatController = new TextEditingController();
  var ioConnection;
  bool visible = false;
  FlatService flatService = new FlatService();
  ChatService chatService = new ChatService();
  UserService userService = new UserService();
  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat & Friends'),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              _chatButton(),
              _eventButton(),
            ],
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('User'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Flat'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void initState() {
    super.initState();
    // Advertisement in case of a user do not has an assigned flat yet
    if (sharedData.getUser().getIdPiso() == null) {
      // Method to load a widget after full loaded page
      WidgetsBinding.instance.addPostFrameCallback((_) => _warningNoFlat());
    }
  }

  // Do an action depending on the pushed button from bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushReplacementNamed(context, '/user');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/flat');
          break;
      }
    });
  }


  // Pop de warning en caso de que el usuario aún no tenga su piso registrado
  Widget _warningNoFlat() {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) { //SingleChildScrollView
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text('¡Hola!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!visible) Column(
                    children: <Widget>[
                      Text('No aparece ningún piso en tu perfil.',),
                      SizedBox(height: 6,),
                      Text(
                        'Si tu piso no se ha registrado nunca, registralo como nuevo, de lo contrario, añade el código de tu piso.',),
                      SizedBox(height: 16,),
                    ],
                  ),


                 if (!visible) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                            child: Text('Registrar uno nuevo'),
                            shape: StadiumBorder(),
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, '/regflat');
                            }
                        ),
                      FlatButton(
                            child: Text('Añadir el tuyo'),
                            shape: StadiumBorder(),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                visible = !visible;
                              });
                            }
                      ),
                    ],
                  ),
                  if (!visible) SizedBox(height: 16,),
                  if (visible) Column(
                    children: <Widget>[
                      Text('Introduce el identificador de tu piso:'),
                      _textFielRegFlat(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                              child: Text('Guardar'),
                              shape: StadiumBorder(),
                              color: Colors.greenAccent,
                              textColor: Colors.white,
                              onPressed: () async {
                                if (idFlatController.text != null && idFlatController.text.length == 24) {
                                  sharedData.getUser().setIdPiso(idFlatController.text);
                                  int res = await userService.updateUser(sharedData.getUser());
                                  if (res == 0) {
                                    int res = await flatService.getFlat();
                                    res = await flatService.getTenantsFlat();
                                    Navigator.of(context).pop();
                                    _warningOnTryRegFlat(
                                        '¡Te has unido al piso!', res);
                                  }
                                  else {
                                    Navigator.of(context).pop();
                                    _warningOnTryRegFlat('¡Error!', res);
                                  }
                                }
                              }
                          ),
                          SizedBox(width: 30,),
                          FlatButton(
                              child: Text('Cancelar'),
                              shape: StadiumBorder(),
                              color: Colors.redAccent,
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  visible = !visible;
                                });
                              }
                          ),
                        ],
                      )
                    ],
                  ),
                  FlatButton(
                    child: Text('Más tarde'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _warningOnTryRegFlat(String s, int res) {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            title: Text(s),
            actions: <Widget>[
              if (res == 0) Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('¡Gracias por usar Flat&Friends!'),
                  FlatButton(
                      child: Text('Aceptar'),
                      shape: StadiumBorder(),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                  ),
                ],
              ),
              if (res != 0) Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Vaya... Parece que ha habido algún problema.' + '\n' +
                      'Por favor, revisa el identificador e inténtalo de nuevo.'),
                  FlatButton(
                      child: Text('Volver a intentar'),
                      shape: StadiumBorder(),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _warningNoFlat();
                      }
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  // Button to access to the chat
  Widget _chatButton() {
    return FlatButton(onPressed: () {
      if (sharedData.chatRunning == true){
        Navigator.pushNamed(context, '/chat');
      }
    },
        child: Text('Chat'),
        shape: StadiumBorder(),
        color: Colors.green,
        textColor: Colors.white);
  }

  Widget _eventButton() {
    return FlatButton(onPressed: () async {
       await flatService.getEventFlat();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/event');
    },
        child: Text('Event'),
        shape: StadiumBorder(),
        color: Colors.purple,
        textColor: Colors.white);
  }

  Widget _textFielRegFlat() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: idFlatController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          labelText: 'Identificador de tu piso',
          hintText: 'Escrbir el identificador.',
          suffixIcon: Icon(Icons.business, color: Colors.green),
        ),
      ),
    );
  }

  Widget _taskButton() {
    return FlatButton(onPressed: () async {

//       await flatService.getTaskFlat();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/task');

    },
        child: Text('Task'),
        shape: StadiumBorder(),
        color: Colors.purple,
        textColor: Colors.white);
  }
}