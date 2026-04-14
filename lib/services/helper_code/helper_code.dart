import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/main.dart';

import '../../module/pages/main_home_page/main_home_page_controller.dart';
import '../../module/pages/main_home_page/main_page_navigation_key.dart';

class helper_code {
  final controller = Get.find<Main_Home_Page_Controller>();

  void helper() {
    int index = controller.current_index.value;

    GlobalKey<NavigatorState>? currentNavigator;

    switch (index) {
      case 0:
        currentNavigator = navigator_key.homeNavKey;
        break;
      case 1:
        currentNavigator = navigator_key.shortsNavKey;
        break;
      case 2:
        currentNavigator = navigator_key.exploreNavKey;
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

void showGlobalMessage(String message){
  messageKey.currentState!.showSnackBar(
    SnackBar(content: Text(message),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 80, // 👈 THIS pushes it above obstacles
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    )
  );
}