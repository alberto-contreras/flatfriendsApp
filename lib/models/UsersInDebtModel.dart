class UsersInDebtModel {
  String _id;
  String _firstname;
  String _amountToPay;
  bool _isPaid;

  UsersInDebtModel();

  setId(String value){
    this._id = value;
  }

  setFirstname(String value){
    this._firstname = value;
  }

  setAmountToPay(String value){
    this._amountToPay = value;
  }
  setIsPaid(bool value){
    this._isPaid = value;
  }

  String getId(){return this._id;}

  String getFirstname(){return this._firstname;}

  String getAmountToPay(){return this._amountToPay;}

  bool getIsPaid(){return this._isPaid;}

  Map<String,dynamic> toJson(){
    return {
      "id": this._id,      
      "firstname": this._firstname,
      "amountToPay": this._amountToPay,
      "isPaid": this._isPaid,
    };
  }
  static List encondeToJson(List<UsersInDebtModel>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();
    return jsonList;
  }
}
