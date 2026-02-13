import 'package:get/get.dart';
import 'package:youtube_music/module/pages/explore/explore_controller.dart';

class Explore_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Explore_Controller>(()=>Explore_Controller());
  }
}