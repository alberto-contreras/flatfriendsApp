import 'package:flatfriendsapp/models/flat.dart';
import 'package:flatfriendsapp/models/user.dart';

class SharedData {

  static  SharedData instance;
  UserModel infoUser;
  FlatModel infoFlat;
  String token;
  String urlDevUser = 'http://10.0.2.2:3702/user/';
  String urlProdUser = '';
  String urlDevFlat = 'http://10.0.2.2:3702/flat/';
  String urlProdFlat = '';

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

  setFlat(FlatModel a)
  {
    this.infoFlat = a;
  }

  UserModel getUser() => this.infoUser;

  FlatModel getFlat() => this.infoFlat;

  String getUrlDevUser() => this.urlDevUser;

  String getUrlProdUser() => this.urlProdUser;

  String getUrlDevFlat() => this.urlDevFlat;

  String getUrlProdFlat() => this.urlProdFlat;





}