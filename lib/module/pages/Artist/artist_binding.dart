import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';


class Artist_Binding extends Bindings {

  @override
  void dependencies() {
    Get.put<Artist_Controller>(Artist_Controller(), permanent: true);
  }
}
