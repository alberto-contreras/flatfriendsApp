import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/Debt.dart';
import 'package:flatfriendsapp/services/flatService.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

SharedData sharedData = SharedData.getInstance();
class RegisterDebt extends StatefulWidget {
  @override
  _RegisterDebtState createState() => _RegisterDebtState();
}

class _RegisterDebtState extends State<RegisterDebt> {
  TextEditingController conceptController = new TextEditingController();
  TextEditingController totalAmountController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  FlatService flatService = new FlatService();
  DebtModel debtToAdd = new DebtModel();
  var date;
  var time;
  var dateEvent;

  void updateTime() async
  {
    Navigator.pop(context);
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos'),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Añadir Gasto',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Divider(),
            _textConcept(),
            Divider(),
            _textTotalAmount(),
            Divider(),
            _textDate(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _registerDebtButton(),     // Creating a button widget for Login
                SizedBox(width: 60,),
                _cancelButton()
              ],
            ), // Creating a button widget for Register
          ],
        ),
      ),
    );
  }

  Widget _textConcept(){
    return TextField(
      controller: conceptController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Escribe el concepto del gasto',
          icon: Icon(Icons.payment)
      ),
    );
  }

  Widget _textTotalAmount(){
    return TextField(
      controller: totalAmountController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Cantidad del pago',
          icon: Icon(Icons.monetization_on)
      ),
    );
  }

  Widget _textDate() {
    final format = DateFormat("dd-MM-yyyy HH:mm");
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'Introduce una fecha.',
            icon: Icon(Icons.date_range)
        ),
        onShowPicker: (context, currentValue) async {
          date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            time = await showTimePicker(
              context: context,
              initialTime:
              TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return dateEvent = DateTimeField.combine(date, time);
          } else {
            return currentValue;

          }
        },
      ),
    ]);
  }

  Widget _registerDebtButton() {
    return FlatButton(onPressed: () async  {
      print('Dentro Registro Gasto');
      if(conceptController.text == null || totalAmountController.text == null || dateEvent == null){
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return _alertRegisterDebt();
            });
      }
      else {
        debtToAdd.setIdPiso(sharedData.getUser().getIdPiso());
        debtToAdd.setConcept(conceptController.text);
        debtToAdd.setTotalAmount(totalAmountController.text);
        debtToAdd.setIdUser(sharedData.getUser().getIdUser());
        debtToAdd.setDate(dateEvent.toString());
        for (int i = 0; i < sharedData.getUsersInFlatToShareDebts().length; i++)
            { //We Set the State of the user that creates the event to 1 (accepted)
          if (sharedData.getUsersInFlatToShareDebts().elementAt(i).getId() ==
              sharedData.getUser().getIdUser()) {
            sharedData.getUsersInFlatToShareDebts().elementAt(i).setIsPaid(true);
          }
          debtToAdd.setUsers(sharedData.getUsersInFlatToShareDebts());
          print('gasto antes de enviar');
        }
        int res = await flatService.addDebtFlat(this.debtToAdd);
        print(res);
        if (res == 0) {
          Navigator.pop(context);
        }
        else {
          //Alert error adding the user
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return _alertRegisterDebt();
              });
        }
      }

    },
        child: Text('Añadir Gasto'),
        shape: StadiumBorder(),
        color: Colors.purple,
        textColor: Colors.white);
  }

  Widget _cancelButton() {
    return FlatButton(onPressed: () {
      Navigator.pop(context);
    },
        child: Text('Cancelar'),
        shape: StadiumBorder(),
        color: Colors.red,
        textColor: Colors.white);
  }

  Widget _alertRegisterDebt(){
    return PlatformAlertDialog(
      title: Text('Hey!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Error en el registro vuelve a intentarlo.'),
            Text('Ayuda: Revisa los datos.'),
          ],
        ),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text('Aceptar'),
          onPressed: () async {
            //Navigator.of(context).pop();
            flatService.getDebtsFlat();
            updateTime();
          },
        ),
      ],
    );
  }

}


