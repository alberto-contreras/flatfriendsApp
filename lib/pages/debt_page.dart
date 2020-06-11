import 'dart:convert';
import 'package:flatfriendsapp/models/Debt.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:http/http.dart'as http;

class Debt extends StatefulWidget {
  @override
  _DebtState createState() => _DebtState();
}

class _DebtState extends State<Debt> {
  List<DebtModel> debts = sharedData.getDebts();
  FlatService flatService = new FlatService();
  //This function it's going use getTime on wherever instance and then once we have the data re root to the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text('Gastos'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FlatButton(
          onPressed: () async{
            await flatService.getUsersFlatForDebt();
            await Navigator.pushNamed(context,'/regdebt');
            //we put in a dynamic variable because when are doing a big async task
            //first we go to the event page and then after adding a new one we pop with a refresh
            await flatService.getDebtsFlat();
            setState(() { });
          },
          child: Text('Añadir Gasto'),
          shape: StadiumBorder(),
          color: Colors.purple[800],
          textColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical:1.0, horizontal: 4.0),
        itemCount: debts.length,
        itemBuilder: (context,index){ //This function will make a widget tree of the one we choose

          return Card(
            margin: const EdgeInsets.only(
              top: 16.0,
              bottom: 1.0,
              left: 24.0,
              right: 24.0,
            ),
            color: getColorDebt(index),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.0),
            ),

            child: ListTile(
              onTap: () async {
                print(debts.elementAt(index).getConcept().toString());
                sharedData.setDebtDetails(debts.elementAt(index));
                await Navigator.pushNamed(context,'/debtDetails');
                //we put in a dynamic variable because when are doing a big async task
                //first we go to the event page and then after adding a new one we pop with a refresh
                await flatService.getDebtsFlat();
              },//Link on press function
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.attach_money, color: Colors.green, size: 30,),
              ),
              title: Text(debts.elementAt(index).getTotalAmount().toString() + 
                          '€ - ' + debts.elementAt(index).getConcept().toString(),                          
                style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              subtitle: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        // tag: 'hero',
                        child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            value: getAccept(index),
                            valueColor: AlwaysStoppedAnimation(Colors.green)),
                      )),
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text('Estado del pago',
                            style: TextStyle(color: Colors.white))),
                  )
                ],
              ),
              trailing: Column(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                  Text('Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          );
        },),
    );
  }
  double getAccept(int position){
    double accept = 0;
    for(int i = 0; i<debts.elementAt(position).getUsers().length;i++){
      if(debts.elementAt(position).getUsers().elementAt(i).getIsPaid()){
        accept = accept +1;
      }
    }
    double percent = accept/debts.elementAt(position).getUsers().length;
    return percent;
  }
  Color getColorDebt(int element){
    //Change the color of the events card depending on
    // the number of people that have accepted, declined or not decided
    DebtModel event = debts.elementAt(element);
    int paid = 0;
    int notdecide = 0;
    
    for(int i=0;i<event.getUsers().length;i++){
      if(event.getUsers().elementAt(i).getIsPaid() ){
        paid = paid +1;
      } else{
        notdecide = notdecide +1;
      }
    }
    if(paid/event.getUsers().length == 1){
      return Colors.green[200];
    }else{
      return Colors.purple[100];
    }
  }
}
