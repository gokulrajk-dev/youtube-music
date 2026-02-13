import 'package:dio/dio.dart';
import 'package:youtube_music/core/network/refresh_dio.dart';

import 'package:youtube_music/services/Token_Service.dart';


// class Auth_Interceptor extends Interceptor{
//   final Dio dio;
//
//   Auth_Interceptor(this.dio);
//   final User_Respository  user_respository = User_Respository();
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     final access = await Token_service.get_access_token();
//     if(access!=null){
//       options.headers['Authorization'] = 'Bearer $access';
//     }
//     super.onRequest(options, handler);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async{
//     if(err.response!.statusCode==401){
//       final refresh = await Token_service.get_refresh_token();
//       if(refresh !=null){
//         try{
//           final data = await user_respository.refreshtokens(refresh);
//           await Token_service.set_access_refresh_token(data['access'], data['refresh']);
//           err.requestOptions.headers['Authorization']='Bearer ${data['refresh']}';
//           final retry_response = await dio.fetch(err.requestOptions);
//           return handler.resolve(retry_response);
//         }catch(e){
//           await Token_service.clear_token();
//         }
//       }
//     }
//     super.onError(err, handler);
//   }
//
// }

class Auth_Interceptor extends Interceptor {
  final Dio dio;
  Auth_Interceptor(this.dio);
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final access = await Token_service.get_access_token();
    if (access != null) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refresh = await Token_service.get_refresh_token();

      if (refresh == null) {
        await Token_service.clear_token();
        return handler.next(err);
      }

      try {
        // 🔥 IMPORTANT: use RefreshDio, NOT dio
        final response = await RefreshDio.dio.post(
          '/user_accounts/auth/token/refresh/',
          data: {'refresh': refresh},
        );

        final newAccess = response.data['access'];
        final newRefresh = response.data['refresh'];

        await Token_service.set_access_refresh_token(
          newAccess,
          newRefresh,
        );

        // Retry original request
        err.requestOptions.headers['Authorization'] =
        'Bearer $newAccess';

        final retryResponse = await dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (_) {
        await Token_service.clear_token();
      }
    }

    handler.next(err);
  }
}
