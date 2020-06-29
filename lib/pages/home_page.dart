import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/pages/user_page.dart';
import 'package:flatfriendsapp/services/chatService.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:flatfriendsapp/transitions/horizontal_transition_left_to_right.dart';
import 'package:flatfriendsapp/transitions/horizontal_transition_right_to_left.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';


import 'flat_page.dart';

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
        actions: <Widget>[
        ],
      ),
      body: Center(
          child:GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              _chatButton(),
              _eventButton(),
              _taskButton(),
              _debtButton(),
              _StatsButton(),
            ],
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Usuario'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Piso'),
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
    _saveSharedPreferences();
  }

  // Save log in in data to auto log in the next time
  void _saveSharedPreferences() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    final credentials = prefs.getString('user') ?? 0;
    if (credentials == 0){
      prefs.setString('user', sharedData.getUser().getEmail());
      prefs.setString('password', sharedData.getUser().getEmail());
      prefs.setBool('googleAuth', sharedData.getUser().getGoogleAuth());
    }
  }

  // Do an action depending on the pushed button from bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.of(context).pop();
          Navigator.push(context,
              EnterLeftExitRightRoute(exitPage: Home(), enterPage: User()));

          break;
        case 2:
          Navigator.of(context).pop();
          Navigator.push(context,
              EnterRightExitLeftRoute(exitPage: Home(), enterPage: Flat()));
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
                          child: Text('Registrar nuevo'),
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
                  if (!visible) FlatButton(
                      child: Text('Ver pisos disponibles'),
                      shape: StadiumBorder(),
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () async {
                        Position currentPosition;
                        bool geolocationStatus  = await Geolocator().isLocationServiceEnabled();
                        print(geolocationStatus);
                        if (geolocationStatus) {
                          currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        } else {
                          currentPosition = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
                        }
                        sharedData.setCurrentPosition(currentPosition);

                        sharedData.availableFlats = await flatService.getAvalibleFlats();
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/availableFlats');
                      }
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
//                                  sharedData.getUser().setIdPiso(idFlatController.text);
//                                  int res = await userService.updateUser(sharedData.getUser());
                                print('Añadiendo tenant: '+ sharedData.getUser().getIdUser() + ' '+idFlatController.text);
                                  int res = await flatService.addTenant(sharedData.getUser().getIdUser(), idFlatController.text);
                                  if (res == 0) {
                                    sharedData.getUser().setIdPiso(idFlatController.text);
                                    await flatService.getFlat();
                                    await flatService.getTenantsFlat();

                                    if (sharedData.getIdChatRoom() != sharedData.getUser().getIdPiso()) {
                                      sharedData.setChatRoomStatus(false);
                                      print('PISO DIFERENTEEEE, LOGINNNN');
                                    }
                                    if (sharedData.getChatRoomStatus() == false){
                                      await sharedData.chatService.initChatService(
                                          sharedData.getUser().getIdPiso());
                                    }
                                    sharedData.chatRunning = true;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('¡Gracias por usar Flat&Friends!'),
                  SizedBox(height: 10,),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (res != 2)Text('Vaya... Parece que ha habido algún problema.' + '\n' +
                      'Por favor, revisa el identificador e inténtalo de nuevo.'),
                  if (res == 2)Text('¡Este piso ya está lleno! Contacta con el Flat admin.'),
                  SizedBox(height: 10,),
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
    return FlatButton(
        onPressed: () async {
          if (sharedData.chatRunning == true && sharedData.getUser().getIdPiso() != null){
            await Navigator.pushNamed(context, '/chat');
            print("antes");
//            sharedData.chatStream.close();
            print("despues");
          }
          else{
            _alertNotInAFlat();
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Image.asset('graphics/chat icon.png',scale: 4.5,),
//              Icon(
//                Icons.chat,
//                color: Colors.white,
//                size: 96.00,
//                semanticLabel: 'Text to announce in accessibility modes',
//              ),
              Text('Chat')
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.green,
        textColor: Colors.white
    );
  }

  Widget _eventButton() {
    return FlatButton(onPressed: () async {
      if(sharedData.getUser().getIdPiso() != null) {
        await flatService.getEventFlat();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/event');
      }
      else{
        _alertNotInAFlat();
      }
    },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Image.asset('graphics/copas icon.png',scale: 4.5,),
              Text('Eventos',)
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.yellow[800],
        textColor: Colors.white);
  }
  Widget _StatsButton() {
    return FlatButton(onPressed: () async {
      if(sharedData.getUser().getIdPiso() != null) {
        await flatService.getTaskFlat();
        await flatService.getUsersFlatForTask();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/stats');
      }
      else{
        _alertNotInAFlat();
      }
    },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.show_chart,size: 120,),
              Text('Estadísticas',)
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.black,
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
      if (sharedData.getUser().getIdPiso() != null) {
        await flatService.getTaskFlat();
        await flatService.getUsersFlatForTask();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/task');
      }
      else {
        _alertNotInAFlat();
      }
    },
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              Image.asset('graphics/tasks icon.png', scale: 2,),
              Text('Tareas')
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.red,
        textColor: Colors.white);
  }

  Widget _debtButton() {
    return FlatButton(onPressed: () async {
      if(sharedData.getUser().getIdPiso() != null) {
        await flatService.getDebtsFlat();
        //print(sharedData.eventsFlat);
        Navigator.pushNamed(context, '/debt');
      }
      else{
        _alertNotInAFlat();
      }
    },
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Image.asset('graphics/piggy bank.png',scale: 4.5,),
              Text('Gastos',)
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        color: Colors.purple[800],
        textColor: Colors.white);
  }

  Widget _alertNotInAFlat() {
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
                  Text('Para acceder debes pertenecer a un piso.'),
                  SizedBox(height: 10,),
                  FlatButton(
                    child: Text('Aceptar'),
                    shape: StadiumBorder(),
                    color: Colors.blue[900],
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        }
    );
  }
}
