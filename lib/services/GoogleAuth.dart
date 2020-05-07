import 'package:flatfriendsapp/globalData/sharedData.dart';
import 'package:flatfriendsapp/models/User.dart';
import 'package:flatfriendsapp/services/userService.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

SharedData sharedData = SharedData.getInstance();
UserService userService = new UserService();
class Oauth2ClientExample {
  Oauth2ClientExample();


  Future<int> fetchFiles() async {
    OAuth2Helper hlp = OAuth2Helper(GoogleOAuth2Client(
        redirectUri: 'com.example.flatfriendsapp:/home',
        customUriScheme: 'com.example.flatfriendsapp'));

    hlp.setAuthorizationParams(
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: '456324064137-jh755v6epavpffouchkjsobfc69rbhg9.apps.googleusercontent.com',
        scopes: ['https://www.googleapis.com/auth/userinfo.profile','https://www.googleapis.com/auth/userinfo.email']);

    http.Response resp =
    await hlp.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json');

    print(resp.body);
    print(resp.statusCode);
    if(resp.statusCode == 200){
      Map userData = jsonDecode(resp.body);
      UserModel userGoogle = new UserModel();
      userGoogle.setGoogleAuth(true);
      userGoogle.setFirstname(userData['given_name']);
      userGoogle.setLastname(userData['family_name']);
      userGoogle.setEmail(userData['email']);
      int answer = await userService.registerUser(userGoogle); // Sending to the database the Google User and checking if already exist
      print(answer);
      if(answer != 2 && answer != null){
        sharedData.setUser(userGoogle);
        int answerToGet = await userService.getUserByEmail(sharedData.getUser().getEmail());
        return 0;
      }
      else{
        return 1;
      }
    }
    return resp.statusCode;
  }
}