import 'package:get/get.dart';
import 'package:youtube_music/module/pages/globle_bottom_sheet/globle_bottom_sheet_controller.dart';

class globle_bottom_sheet_binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<globle_bottom_sheet_controller>(()=> globle_bottom_sheet_controller());
  }
}