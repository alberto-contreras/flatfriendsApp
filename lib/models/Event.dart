
class EventModel{
   String _idPiso;
   String _name;
   String _organizer;
   String _description;
   String _date;
   EventModel();

  String getIdPiso()=> this._idPiso;

  String getName()=> this._name;

  String getOrganizer()=> this._organizer;

  String getDescription()=> this._description;

  String getDate()=> this._date;

  void setIdPiso(String value){
    this._idPiso = value;
  }

  void setName(String value){
    this._name = value;
  }

  void setOrganizer(String value){
    this._organizer = value;
  }

  void setDescription(String value){
    this._description = value;
  }

  void setDate(String value){
    this._date = value;
  }

}




