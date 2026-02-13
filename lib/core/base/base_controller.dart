import 'package:get/get.dart';

abstract class base_controller extends GetxController{
  final is_loading = false.obs;
  final error= ''.obs;

  void get_isloading(bool loading){
    is_loading.value=loading;
  }
  void get_error(String message){
    error.value=message;
  }
  void noerror(){
    error.value='';
  }

}