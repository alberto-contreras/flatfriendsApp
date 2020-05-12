class ChatMessageModel {
  String _room;
  String _userName;
  String _message;
  String _dateTime;

  ChatMessageModel();

  setChatRoom(String value){
    this._room = value;
  }

  setUserName(String value){
    this._userName = value;
  }

  setMessage(String value){
    this._message = value;
  }

  setDateTime(String value){
    this._dateTime = value;
  }

  String getChatRoom() => this._room;

  String getUserName() => this._userName;

  String getMessage() => this._message;

  String getDateTime() => this._dateTime;

}