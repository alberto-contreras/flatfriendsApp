

class UserModel {
  String _firstname;
  String _lastname;
  String _email;
  String _phoneNumber;
  String _idPiso;
  String _password;

  String get firstname => _firstname;

  UserModel();

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
  String getFirstname (){ return _firstname;}
  String getLastname (){ return _lastname;}

  String getPassword (){ return _password;}

  String getIdPiso(){ return _idPiso;}

  String getPhoneNumber (){ return _phoneNumber;}

  String getEmail (){ return _email;}

}