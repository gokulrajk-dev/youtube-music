import 'package:dio/dio.dart';

import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/core/network/Dio_Public_Client.dart';

import 'package:youtube_music/data/data_module/user_details.dart';

class User_Respository {
  final Dio dio = Dio_public_client().dio;
  final Dio dio1 = Dio_Private_Client().dio;

  Future<Map<String,dynamic>> get_new_login(String googleIdToken) async{
    final response = await dio.post(Api_Endpoint.new_login,data: {
      'google_id_token':googleIdToken
    });
    return response.data;
  }

  Future<Map<String,dynamic>> refreshtokens (String refreshtoken) async{
    final response = await dio.post(Api_Endpoint.refresh_token,data: {
      'refresh':refreshtoken
    });
    return response.data;
  }
  Future<UserDetails> get_currents_user() async{
    final response = await dio1.get(Api_Endpoint.get_current_user);
    return UserDetails.fromJson(response.data[0]);
  }


}