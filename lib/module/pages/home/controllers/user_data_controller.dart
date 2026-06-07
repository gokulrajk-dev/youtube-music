import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';

import '../../../../data/data_module/user_details.dart';
import '../../../../data/user_respository/user_respository.dart';

class user_details_controller extends base_controller {
  final user = Rxn<UserDetails>();
  final User_Respository _userRespository = User_Respository();

  @override
  void onInit() {
    fetch_user();
    super.onInit();
  }

  Future<void> clear_user() async {
    user.value = null;
  }

  Future<void> fetch_user() async {
    try {
      get_isloading(true);
      noerror();
      user.value = await _userRespository.get_currents_user();
    } catch (e) {
      error.value = '${e.toString()}';
    } finally {
      get_isloading(false);
    }
  }
}
