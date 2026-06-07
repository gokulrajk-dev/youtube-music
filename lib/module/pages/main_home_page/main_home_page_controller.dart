import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../library/library_views.dart';

class Main_Home_Page_Controller extends GetxController {
  var current_index = 0.obs;

  void get_current_index(int index) {
    if (current_index.value == index && index == 3) {
      Get.bottomSheet(
        isDismissible: false,
        DraggableScrollableSheet(
          builder: (context, scrollController) {
            return showPlaylistBottom();
          },
        ),
      );
    }
    current_index.value = index;
  }
}
