import 'package:get/get.dart';

import 'download_controller.dart';


class download_binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<download_Controller>(()=>download_Controller());
  }
}