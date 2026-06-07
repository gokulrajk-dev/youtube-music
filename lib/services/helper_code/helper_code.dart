import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/main.dart';
import 'package:youtube_music/route/app_route.dart';

import '../../module/pages/main_home_page/main_home_page_controller.dart';
import '../../module/pages/main_home_page/main_page_navigation_key.dart';

class helper_code {
  static void helper() {
    final controller = Get.find<Main_Home_Page_Controller>();
    int index = controller.current_index.value;

    GlobalKey<NavigatorState>? currentNavigator;

    switch (index) {
      case 0:
        currentNavigator = navigator_key.homeNavKey;
        break;
      case 1:
        currentNavigator = navigator_key.searchNavKey;
        break;
      case 2:
        currentNavigator = navigator_key.shortsNavKey;
        break;
      case 3:
        currentNavigator = navigator_key.libraryNavKey;
        break;
    }

    if (currentNavigator != null &&
        currentNavigator.currentState != null &&
        currentNavigator.currentState!.canPop()) {
      currentNavigator.currentState!.pop();
      return;
    } else {
      Get.back();
    }
  }
}

class NavHelper {
  static int getNavId(int index) {
    switch (index) {
      case 0:
        return 1; // home
      case 1:
        return 2; // shorts
      case 2:
        return 3; // explore
      case 3:
        return 4; // library
      default:
        return 1;
    }
  }
}

void showGlobalMessage(String message, [String page = ""]) {
  messageKey.currentState!.showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(message),
        if (page.isNotEmpty)
          Builder(builder: (context) {
            return TextButton(
                onPressed: () {
                  if (page == "like") {
                    Get.back();
                    final mainPage = Get.find<Main_Home_Page_Controller>();
                    final naviId =
                        NavHelper.getNavId(mainPage.current_index.value);
                    Get.toNamed(App_route.like_page, id: naviId);
                  }
                },
                child: Text("Like Music"));
          })
      ],
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(
      left: 12,
      right: 12,
      bottom: 80,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ));
}
