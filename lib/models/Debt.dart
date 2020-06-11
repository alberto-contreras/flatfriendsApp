import 'package:flatfriendsapp/models/UsersInDebtModel.dart';

class DebtModel{
   String _id;
   String _idPiso;
   String _idUser;
   String _totalAmount;
   String _concept;   
   String _date;
   List<UsersInDebtModel> _users = new List<UsersInDebtModel>();
   DebtModel();

  String getId() => this._id;

  String getIdPiso()=> this._idPiso;

  String getIdUser()=> this._idUser;

  String getTotalAmount()=> this._totalAmount;

  String getConcept()=> this._concept;

  String getDate()=> this._date;

  List<UsersInDebtModel> getUsers() => this._users;

  void setId(String value){
    this._id = value;
  }
  void setIdPiso(String value){
    this._idPiso = value;
  }

  void setIdUser(String value){
    this._idUser = value;
  }

  void setTotalAmount(String value){
    this._totalAmount = value;
  }

  void setConcept(String value){
    this._concept = value;
  }

  void setDate(String value){
    this._date = value;
  }

   void setUsers(List<UsersInDebtModel> value){
     this._users = value;
   }
   void setSpecificUser(UsersInDebtModel value){
    this._users.add(value);
   }

}