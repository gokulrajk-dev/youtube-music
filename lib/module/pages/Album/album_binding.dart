import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';

class Album_Binding extends Bindings {

  @override
  void dependencies() {
    Get.put<Album_Controller>(Album_Controller(), permanent: true);
  }
}
