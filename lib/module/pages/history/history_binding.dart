import 'package:get/get.dart';
import 'package:youtube_music/module/pages/history/history_controller.dart';

class Histroy_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Histroy_Controller>(()=>Histroy_Controller());
  }
}