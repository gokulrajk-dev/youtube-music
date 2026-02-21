import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/route/app_route.dart';



class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500),() { Get.offAllNamed(App_route.login_pag);});
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
