import 'package:get/get.dart';

class Main_Home_Page_Controller extends GetxController{
  var current_index =0.obs;

  void get_current_index(int index){
    // if(current_index==index) return;
    current_index.value =index;
  }

}