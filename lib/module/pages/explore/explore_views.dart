import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/explore/explore_controller.dart';

class Explore_Views extends GetView<Explore_Controller>{
    Explore_Views({super.key}){
      Get.lazyPut<Explore_Controller>(()=>Explore_Controller(),fenix: true);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Explore page'),
      ),
    );
  }
}
