import 'package:get/get.dart';
import 'package:youtube_music/module/pages/library/library_controller.dart';

import 'download/download_controller.dart';

class Library_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Library_Controller>(()=>Library_Controller(),fenix: false);
    Get.lazyPut<download_Controller>(()=>download_Controller());
  }
}