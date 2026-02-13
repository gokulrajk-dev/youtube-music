import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/auth_service.dart';

class auth_guard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Auth_service.isAuthenticate && route == App_route.login_pag ) {
      return RouteSettings(name: App_route.main_home_pages);
    }

    if (!Auth_service.isAuthenticate && route != App_route.login_pag) {
      return RouteSettings(name: App_route.login_pag);
    }
    return null;
  }
}
