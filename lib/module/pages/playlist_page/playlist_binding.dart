import 'package:get/get.dart';

import 'package:youtube_music/module/pages/playlist_page/playlist_controller.dart';

class Playlist_Binding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Playlist_Controller>(()=>Playlist_Controller());
  }
}