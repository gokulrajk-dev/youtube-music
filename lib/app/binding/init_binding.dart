import 'package:get/get.dart';

import '../../module/pages/home/controllers/all_song_controller.dart';

class Init_Binding extends Bindings{
  @override
  void dependencies() {
    Get.put<get_all_song_controller>(get_all_song_controller(),permanent: true);
  }
}