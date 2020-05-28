class UsersInFlatModel {
  String _id;
  String _status;
  String _firstname;

  UsersInFlatModel();

  setId(String id) {
    this._id = id;
  }

  setStatus(String value) {
    this._status = value;
  }

  setFirstname(String value) {
    this._firstname = value;
  }

  String getId() => this._id;

  String getStatus() => this._status;

  String getFirstname() => this._firstname;


  Map<String,dynamic> toJson(){
    return {
      "id": this._id,
      "status": this._status,
      "firstname": this._firstname,
    };
  }
  static List encondeToJson(List<UsersInFlatModel>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();
    return jsonList;
  }
}