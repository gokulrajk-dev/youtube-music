import 'package:get/get.dart';

import 'like_controller.dart';

class Like_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Like_Controller>(()=>Like_Controller());
  }
}