import 'package:flatfriendsapp/models/flat.dart';
import 'package:flatfriendsapp/models/user.dart';

class SharedData {

  static  SharedData instance;
  UserModel infoUser;
  FlatModel infoFlat;
  String token;

  SharedData();

  static SharedData getInstance()
  {
    if(instance == null)
    {
      instance = SharedData();
    }
    return instance;
  }

  setUser(UserModel a)
  {
    this.infoUser = a;
    print(infoUser.getEmail());
  }

  UserModel getUser()
  {
    return this.infoUser;
  }

  setFlat(FlatModel a)
  {
    this.infoFlat = a;
  }

  FlatModel getFlat()
  {
    return this.infoFlat;
  }





}