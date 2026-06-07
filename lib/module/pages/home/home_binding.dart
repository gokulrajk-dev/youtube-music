import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';

import '../like_page/like_controller.dart';




class home_binding extends Bindings{
  @override
  void dependencies() {
    Get.put<user_details_controller>(user_details_controller(),permanent: true);
    Get.lazyPut<Like_Controller>(()=>Like_Controller(),);
  }
}