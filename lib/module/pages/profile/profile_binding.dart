import 'package:get/get.dart';
import 'package:youtube_music/module/pages/profile/profile_controller.dart';

class Profile_binding extends Bindings{
 @override
  void dependencies() {
    Get.lazyPut<Profile_Controller>(()=>Profile_Controller());
  }
}