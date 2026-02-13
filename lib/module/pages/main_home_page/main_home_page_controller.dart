import 'package:get/get.dart';
import 'package:youtube_music/module/pages/explore/explore_controller.dart';
import 'package:youtube_music/module/pages/home/home_binding.dart';
import 'package:youtube_music/module/pages/library/library_controller.dart';
import 'package:youtube_music/module/pages/shorts/shorts_controller.dart';

import '../home/controllers/user_data_controller.dart';

class Main_Home_Page_Controller extends GetxController{
  var current_index =0.obs;

  void get_current_index(int index){
    // if(current_index==index) return;
    current_index.value =index;
  }

}