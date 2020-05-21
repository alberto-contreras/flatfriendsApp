class UsersInFlatModel {
  String _id;
  String _status;

  UsersInFlatModel();

  setId(String id) {
    this._id = id;
  }

  setStatus(String value) {
    this._status = value;
  }

  String getId() => this._id;

  String getStatus() => this._status;

  Map<String,dynamic> toJson(){
    return {
      "id": this._id,
      "status": this._status,
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