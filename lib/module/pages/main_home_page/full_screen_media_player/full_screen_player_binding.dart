import 'package:get/get.dart';

import 'full_screen_player_controller.dart';

class full_player_binding extends Bindings{
  @override
  void dependencies() {
    Get.put<full_screen_media_player_controller>(full_screen_media_player_controller(),permanent: true);
  }
}