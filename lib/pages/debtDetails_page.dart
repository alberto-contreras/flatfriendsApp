import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Debt.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:platform_alert_dialog/platform_alert_dialog.dart';


SharedData sharedData = SharedData.getInstance();

class DebtDetails extends StatefulWidget {
  @override
  _DebtDetailsState createState() => _DebtDetailsState();
}

class _DebtDetailsState extends State<DebtDetails> {
  DebtModel debt = sharedData.getDebtDetails();
  FlatService flatService = new FlatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Detalles del Gasto'),
        centerTitle: true,
        backgroundColor: Colors.purple[900],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: SizedBox(

                width: 250.0,
                child: ColorizeAnimatedTextKit(
                    onTap: () {
                      print("Tap Debt");
                    },
                    text: [
                      "" + debt.getConcept(),
                    ],
                    textStyle: TextStyle(
                        fontSize: 40.0,
                        fontFamily: "Horizon",
                        fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      Colors.purple,
                      Colors.blue,

                      Colors.red,
                    ],
                    textAlign: TextAlign.center,
                    alignment: AlignmentDirectional
                        .topCenter // or Alignment.topLeft
                ),
              ),
            ),
            Divider(
              height: 30,
              color: Colors.black,
            ),
            Text(
              'Coste: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            Text(
              '' + debt.getTotalAmount().toString() + ' €',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0), //Space between two widgets
            Text(
              'A pagar por persona: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Precio a pagar por persona',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Fecha: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            Text(
              '' + debt.getDate().substring(0,16),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Estado del Pago: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0), //Space between two widgets
            _showNumberOfAccept(),
            SizedBox(height: 20,),            
            _showAcceptDecline(),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }


  Widget _showAcceptDecline() {
    bool found = false;
    bool exist = false;
    for (int i = 0; i < debt.getUsers().length; i++) {
      //Comprobamos que el usuario no tenga el estado a 1 o a 2, es decir ya haya aceptado o rechazado el evento
      if ((debt.getUsers().elementAt(i).getId() == sharedData.getUser().getIdUser()) && (debt.getUsers().elementAt(i).getIsPaid() != true)) {
        found = true;
        print('YA HE PAGADO');
      }
    }
    int i=0;
    while(!exist){
      //Comprobamos que el usuario se encuentre o no en la lista del evento y en caso de que no se encuentre
      //mostrale el mensaje de "No pertenecias al piso cuando se creo el evento"
      if(debt.getUsers().elementAt(i).getId() == sharedData.getUser().getIdUser()) {
        exist = true;
        break;
      }
      else{
        i++;
      }
      if(i >= debt.getUsers().length){
         break;
      }

    }

    if (found != true && exist == true) {
      return Row(
        children: <Widget>[
          //Hemos de actualizar la lista con el estado que ha decidio el usuario y enviarla (estado = 1) --> ACEPTADO
          FlatButton.icon(onPressed: () async {
            for (int i = 0; i < debt
                .getUsers()
                .length; i++) {
              if (debt.getUsers().elementAt(i).getId() ==
                  sharedData.getUser().getIdUser()) {
                debt.getUsers().elementAt(i).setIsPaid(true);
                int res = await flatService.updateDebtFlat(debt);
                if (res == 0) {
                  Navigator.pop(context);
                }
                else {
                  print('Error');
                }
              }
            }
          },
            icon: Icon(Icons.assignment_turned_in),
            label: Text('Pagado'),
            shape: StadiumBorder(),
            color: Colors.green,
            textColor: Colors.white,),
          SizedBox(width: 20),
          
          
        ],
      );
    }
    else if(found == true && exist == true){
      return Card(
        margin: const EdgeInsets.only(
          top: 16.0,
          bottom: 1.0,
          left: 10.0,
          right: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0),
        ),
        color:Colors.deepPurple,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 5.0)),
            Icon(Icons.all_inclusive,color: Colors.white70,),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Text('Gracias por haber pagado',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              )
            )
          ],
        ),
      );
    }
    else if(exist == false){
      return Card(
        margin: const EdgeInsets.only(
          top: 16.0,
          bottom: 1.0,
          left: 10.0,
          right: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0),
        ),
        color:Colors.deepPurple,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 5.0)),
            Icon(Icons.all_inclusive,color: Colors.white70,),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Text('No estabas en el piso durante el pago',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold

              ),)
          ],
        ),
      );
    }
  }

  //Here we show de stadistics about how many people have accept this event
  Widget _showNumberOfAccept() {
    List <String> usernamePaid = new List <String>();
    int paid = 0;
    for(int i = 0; i<debt.getUsers().length;i++){
      if(debt.getUsers().elementAt(i).getIsPaid()){
        paid = paid +1;
        print(debt.getUsers().elementAt(i).getFirstname());
        usernamePaid.add(debt.getUsers().elementAt(i).getFirstname());
      }
    }
    return Column(
      children:<Widget>[
        ExpansionTile(
          backgroundColor: Colors.green[100],
          title: Row(
          children: <Widget>[
            Icon(Icons.thumb_up,size:20 ,color: Colors.green,),
            SizedBox(width: 20),
            Expanded(
                flex: 1,
                child: Container(
                  height: 10,
                  width: 20,
                  // tag: 'hero',
                  child: LinearProgressIndicator(

                      backgroundColor: Colors.grey[100],
                      value: getPaid(),
                      valueColor: AlwaysStoppedAnimation(Colors.green)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Han pagado '+paid.toString()+'/'+debt.getUsers().length.toString()+' personas',
                      style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold, fontSize: 14))),
            ),
          ],
        ),
        children: <Widget>[
            ListView.builder(
             itemCount:usernamePaid.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
               return Text('   ' + usernamePaid.elementAt(index).toString(),
                     style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold, fontSize: 18),);
               },),
          SizedBox(height: 20,)
        ],)],
    );

  }  
  //We get the percent of paid
  double getPaid(){
    double paid = 0;
    for(int i = 0; i<debt.getUsers().length;i++){
      if(debt.getUsers().elementAt(i).getIsPaid()){
        paid = paid +1;
      }
    }
    double percent = paid/debt.getUsers().length;
    return percent;
  }
  
}