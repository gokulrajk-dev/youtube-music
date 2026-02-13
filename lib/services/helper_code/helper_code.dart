import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../module/pages/main_home_page/main_home_page_controller.dart';
import '../../module/pages/main_home_page/main_page_navigation_key.dart';

class helper_code {
  final controller = Get.find<Main_Home_Page_Controller>();
 void helper(){
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

  if(currentNavigator !=null &&  currentNavigator.currentState !=null && currentNavigator.currentState!.canPop()){
    currentNavigator.currentState!.pop();
    return;
  }else {
    Get.back();
  }
}
}