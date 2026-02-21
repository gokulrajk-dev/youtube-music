import 'package:get/get.dart';

import 'package:youtube_music/module/pages/main_home_page/main_home_page_controller.dart';

import '../home/controllers/all_song_controller.dart';


class Main_Home_Page_Binding extends Bindings{
  @override
  void dependencies() {
    Get.put(Main_Home_Page_Controller(),permanent: true);
    Get.put<get_current_song>(get_current_song(),permanent: true);
    // Get.put<user_details_controller>(user_details_controller(),permanent: true);
  }
}