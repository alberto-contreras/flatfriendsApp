class UserModel {
  String _id;
  String _firstname;
  String _lastname;
  String _email;
  String _phoneNumber;
  String _idPiso;
  String _password;

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

  String getIdUser() => this._id;

  String getFirstname() => this._firstname;

  String getLastname() => this._lastname;

  String getPassword() => this._password;

  String getIdPiso() => this._idPiso;

  String getPhoneNumber() => this._phoneNumber;

  String getEmail() => this._email;
}