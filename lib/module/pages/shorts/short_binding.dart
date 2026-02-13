import 'package:get/get.dart';

import 'package:youtube_music/module/pages/shorts/shorts_controller.dart';

class Short_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Shorts_Controller>(()=>Shorts_Controller());
  }
}