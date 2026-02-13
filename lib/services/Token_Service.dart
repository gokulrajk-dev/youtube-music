
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token_service {
  static final _storage = const FlutterSecureStorage();

  static Future<String?> get_access_token() async{
    return await _storage.read(key: 'access');
  }

 static Future<String?> get_refresh_token() async{
    return await _storage.read(key: 'refresh');
  }
 static Future<void> set_access_refresh_token(String access,String refresh) async{
    await _storage.write(key: 'access', value: access);
    await _storage.write(key: 'refresh', value: refresh);
  }
  static Future<void> clear_token() async{
    _storage.deleteAll();
  }
}