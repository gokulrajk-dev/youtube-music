import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';

import '../Song_search/views/search_views.dart';
import '../library/library_views.dart';

class Main_Home_Page_Controller extends base_controller {
  var current_index = 0.obs;
  final FocusNode focusNode= FocusNode();

  Future<void> refreshHome(List<Future> futures) async {
    try {
      get_isloading(true);
      Future.wait(futures);
      update();
    } finally {
      get_isloading(false);
    }
  }

  void get_current_index(
      int index,
      GlobalKey<SearchViewsState>? searchKey,
      ) {
    if (current_index.value == index && index == 1) {
      print("tap the search again");
      // searchKey?.currentState?.activateFocus();
      focusNode.unfocus();

      Future.delayed(const Duration(milliseconds: 50), () {
        focusNode.requestFocus();
      });
    }

    if (current_index.value == index && index == 3) {
      Get.bottomSheet(
        isDismissible: false,
        DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return const showPlaylistBottom();
          },
        ),
      );
    }

    current_index.value = index;
  }

}
