
class TaskModel{
  String _id;
  String _idPiso;
  String _tittle;
  String _description;
  String _idUser;
  bool done;
  TaskModel();

  String getId() => this._id;

  String getIdPiso()=> this._idPiso;

  String getTittle()=> this._tittle;

  String getDescription()=> this._description;

  String getIdUser()=> this._idUser;

  bool getDone() => this.done;

  void setIdPiso(String value){
    this._idPiso = value;
  }

  void setTittle(String value){
    this._tittle = value;
  }

  void setDescription(String value){
    this._description = value;
  }

  void setIdUser(String value){
    this._idUser = value;
  }

  void setDone(bool state) {
    print("Value: $state");
    this.done = state;
    print("Done: " + this.done.toString());
  }

  void switchDone() {
    this.done = !this.done;
  }

  void setId(String _id) {
    this._id = _id;
  }
}




