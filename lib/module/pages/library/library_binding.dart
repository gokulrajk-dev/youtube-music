import 'package:get/get.dart';
import 'package:youtube_music/module/pages/library/library_controller.dart';

import '../download/download_controller.dart';
import '../playlist_page/playlist_controller.dart';

class Library_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Library_Controller>(()=>Library_Controller(),fenix: false);
    Get.lazyPut<download_Controller>(()=>download_Controller());
    Get.lazyPut<Playlist_Controller>(()=>Playlist_Controller());
  }
}
