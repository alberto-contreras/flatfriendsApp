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
    _password = value;
  }

  setIdPiso(String value) {
    _idPiso = value;
  }

  setPhoneNumber(String value) {
    _phoneNumber = value;
  }

  setEmail(String value) {
    _email = value;
  }

  setLastname(String value) {
    _lastname = value;
  }

  setFirstname(String value) {
    _firstname = value;
  }

  String getIdUser() => this._id;

  String getFirstname() => _firstname;

  String getLastname() => _lastname;

  String getPassword() => _password;

  String getIdPiso() => _idPiso;

  String getPhoneNumber() => _phoneNumber;

  String getEmail() => _email;
}