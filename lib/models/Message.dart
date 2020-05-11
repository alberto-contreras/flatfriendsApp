
class MessageModel {
  String _room;
  String _fromUser;
  String _content;
  String _date;

  MessageModel();

  setRoom(String room) {
    this._room = room;
  }

  setFromUser(String fromUser) {
    this._fromUser = fromUser;
  }

  setContent(String content) {
    this._content = content;
  }

  setDate(String date) {
    this._date = date;
  }

  String getContent() => this._content;

  String getFromUser() => this._fromUser;

  String getDate() => this._date;

  String getRoom() => this._room;
}