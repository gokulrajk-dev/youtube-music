import 'package:get/get.dart';
import 'package:youtube_music/module/pages/library/download/download_controller.dart';

class download_binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<download_Controller>(()=>download_Controller());
  }
}