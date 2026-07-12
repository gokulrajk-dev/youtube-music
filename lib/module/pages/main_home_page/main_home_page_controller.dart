import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/module/pages/Song_search/controllers/search_controller.dart';

import '../../../services/helper_code/helper_code.dart';
import '../Song_search/views/search_views.dart';
import '../library/library_views.dart';
import 'main_page_navigation_key.dart';

class Main_Home_Page_Controller extends base_controller {
  var current_index = 0.obs;
  final FocusNode focusNode = FocusNode();

  // todo optimize this code.
  final Search_Controller searchController = Get.put(Search_Controller());

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

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
    // Clear search when leaving the Search tab
    if (index != 1) {
      searchController.clearSearch();
    }

    // Only handle when the user taps the current tab again
    if (current_index.value == index) {
      NavigatorState? navigator;

      switch (index) {
        case 0:
          navigator = navigator_key.homeNavKey!.currentState;
          break;
        case 1:
          navigator = navigator_key.searchNavKey!.currentState;
          break;
        case 2:
          navigator = navigator_key.shortsNavKey!.currentState;
          break;
        case 3:
          navigator = navigator_key.libraryNavKey!.currentState;
          break;
      }

      if (navigator?.canPop() ?? false) {
        helper_code.helper();
        return;
      }

      switch (index) {
        case 1:
          focusNode.unfocus();

          Future.delayed(const Duration(milliseconds: 50), () {
            focusNode.requestFocus();
          });
          break;

        case 3:
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
          break;
      }

      return;
    }

    current_index.value = index;
  }
}
