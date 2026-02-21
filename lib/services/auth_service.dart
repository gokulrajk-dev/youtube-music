
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:youtube_music/data/user_respository/user_respository.dart';
import 'package:youtube_music/services/Token_Service.dart';


class Auth_service {
 static final User_Respository user_respository = User_Respository();
 static bool isAuthenticate = false;
 static String get ip{
 final url =   dotenv.env['API_BASE_URL'];
 if(url == null|| url.isEmpty){
   throw Exception('ip not found in .env');
 }
 return url;
 }


  // static Future<void> hasTokenValid() async {
  //   final access_token = await _storage.read(key: 'access');
  //   final refresh_token = await _storage.read(key: 'refresh');
  //
  //   if (access_token == null) {
  //     print('access token expired');
  //     isAuthenticate = false;
  //     return;
  //   }
  //   if (!JwtDecoder.isExpired(access_token)) {
  //     print('access token valid');
  //     isAuthenticate = true;
  //     return;
  //   }
  //
  //   if (refresh_token == null) {
  //     isAuthenticate = false;
  //     return;
  //   }
  //
  //   if(JwtDecoder.isExpired(access_token)){
  //     print('access token is expired so refresh token run');
  //   try {
  //     final response = await http.post(
  //         Uri.parse('$ip/user_accounts/auth/token/refresh/'),
  //         headers: {"Content-Type":"application/json"},
  //       body: jsonEncode({"refresh":refresh_token})
  //     );
  //     print('${response.body}');
  //     if(response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       await _storage.write(key: 'access', value: data['access']);
  //       await _storage.write(key: 'refresh', value: data['refresh']);
  //       isAuthenticate = true;
  //     }else{
  //       isAuthenticate=false;
  //     }
  //
  //   } catch (e) {
  //     print("${e.toString()}");
  //     isAuthenticate=false;
  //   }}
  // }
  static Future<void> hasTokenValid() async {
    final access_token = await Token_service.get_access_token();
    final refresh_token = await Token_service.get_refresh_token();

    // if (access_token == null) {
    //   print('access token expired');
    //   isAuthenticate = false;
    //   return;
    // }

    if(access_token!=null){
      isAuthenticate = true;
      return;
    }


    // if (!JwtDecoder.isExpired(access_token)) {
    //   print('access token valid');
    //   isAuthenticate = true;
    //   return;
    // }

    // if (refresh_token == null) {
    //   isAuthenticate = false;
    //   return;
    // }
    //
    // if(JwtDecoder.isExpired(access_token)){
    //   print('access token is expired so refresh token run');
    // try {
    //   final data = await user_respository.refreshtokens(refresh_token);
    //   print('${data}');
    //   Token_service.set_access_refresh_token(data['access'], data['refresh']);
    //   isAuthenticate = true;
    // } catch (e) {
    //   print("${e.toString()}");
    //   isAuthenticate=false;
    // }}
  }
}
