// import 'package:get/get.dart';
// import 'package:youtube_music/module/pages/Song_search/controllers/search_controller.dart';
//
//
// class search_song_binding extends Bindings{
//   @override
//   void dependencies() {
//     Get.lazyPut<search_Controller>(()=>search_Controller(),fenix: true);
//   }
// }

import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Song_search/controllers/search_controller.dart';

class SearchSongBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: true → controller survives tab switches and is recreated on demand
    Get.lazyPut<Search_Controller>(() => Search_Controller(), fenix: true);
  }
}