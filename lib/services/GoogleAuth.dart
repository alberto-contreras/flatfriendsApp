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
        //clientId: '456324064137-bkcl1cgmn3iqu7jh40uv1tfu3agmkupv.apps.googleusercontent.com',
        clientId: '456324064137-jh755v6epavpffouchkjsobfc69rbhg9.apps.googleusercontent.com',
        scopes: ['https://www.googleapis.com/auth/userinfo.profile','https://www.googleapis.com/auth/userinfo.email']);

    http.Response resp =
    await hlp.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json');

    /**
     * After defining the basic parameters for enable sign in with google
     * we work with the response that google server send to us with user data
     */

    print(resp.body);
    print(resp.statusCode);
    if(resp.statusCode == 200){
      Map userData = jsonDecode(resp.body);
      UserModel userGoogle = new UserModel();
      userGoogle.setGoogleAuth(true);
      userGoogle.setFirstname(userData['given_name']);
      userGoogle.setLastname(userData['family_name']);
      userGoogle.setEmail(userData['email']);
      /**
       * Now we send the userGoogle to our backend to register
       */
      int answer = await userService.registerUser(userGoogle);
      print(answer);
      /**
       * If the answer of the register is 2 or null (means that we can not add this user)
       * we return a 1 to the login page in order to show an error POPUP
       */
      if(answer != 2 && answer != null){
        /**
         * If it's different of 2 and null  what we do is sending a GET
         * to the backend and getting all the other fields that we need
         * that google does not provide because are those provided by our backend
         * like user_id, flat_id, phoneNumber
         * Finally we return a 0 in order to navigate to /home page
         */
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