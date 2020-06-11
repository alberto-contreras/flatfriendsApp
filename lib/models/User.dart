
class UserModel {
  String _id;
  String _firstname;
  String _lastname;
  String _email;
  String _phoneNumber;
  String _idPiso;
  String _password;
  bool _googleAuth;
  String _urlUserAvatar;
  int _allTasks;


  UserModel();

  setIdUser(String id){
    this._id = id;
  }

   setPassword(String value) {
    this._password = value;
  }

  setIdPiso(String value) {
    this._idPiso = value;
  }

  setPhoneNumber(String value) {
    this._phoneNumber = value;
  }

  setEmail(String value) {
    this._email = value;
  }

  setLastname(String value) {
    this._lastname = value;
  }

  setFirstname(String value) {
    this._firstname = value;
  }
  setGoogleAuth(bool value){
    this._googleAuth = value;
  }
  setAllTasks(int value){
    this._allTasks = value;
  }

  setUrlAvatar(String value){
    this._urlUserAvatar = value;
  }

  String getIdUser() => this._id;

  String getFirstname() => this._firstname;

  String getLastname() => this._lastname;

  String getPassword() => this._password;

  String getIdPiso() => this._idPiso;

  String getPhoneNumber() => this._phoneNumber;

  String getEmail() => this._email;

  bool getGoogleAuth() => this._googleAuth;


  String getUrlAvatar() => this._urlUserAvatar;

  int getAllTasks() => this._allTasks;

}