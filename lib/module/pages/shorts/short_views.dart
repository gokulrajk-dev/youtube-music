import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/shorts/shorts_controller.dart';

class Shorts_Views extends GetView<Shorts_Controller> {
  Shorts_Views({super.key}){
    Get.lazyPut<Shorts_Controller>(()=>Shorts_Controller(),fenix: true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('shorts page'),
      ),
    );
  }
}
