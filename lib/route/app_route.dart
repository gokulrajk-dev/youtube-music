import 'package:get/get.dart';
import 'package:youtube_music/app/binding/init_binding.dart';
import 'package:youtube_music/main.dart';
import 'package:youtube_music/module/pages/explore/explore_binding.dart';
import 'package:youtube_music/module/pages/explore/explore_views.dart';
import 'package:youtube_music/module/pages/library/download/download_binding.dart';
import 'package:youtube_music/module/pages/library/download/download_views.dart';
import 'package:youtube_music/module/pages/library/library_binding.dart';
import 'package:youtube_music/module/pages/library/library_views.dart';
import 'package:youtube_music/module/pages/library/like_page/like_binding.dart';
import 'package:youtube_music/module/pages/library/like_page/like_views.dart';
import 'package:youtube_music/module/pages/library/playlist_page/playlist_binding.dart';
import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_media_player.dart';
import 'package:youtube_music/module/pages/main_home_page/main_home_page_binding.dart';
import 'package:youtube_music/module/pages/profile/profile_binding.dart';
import 'package:youtube_music/module/pages/profile/profile_views.dart';
import 'package:youtube_music/module/pages/shorts/short_binding.dart';
import 'package:youtube_music/module/pages/shorts/short_views.dart';
import 'package:youtube_music/route/middleware/auth_guard.dart';
import '../module/pages/library/playlist_page/playlist_view.dart';
import '../module/pages/main_home_page/Main_Home_Page.dart';
import '../module/pages/home/home_binding.dart';
import '../module/pages/home/music_home_page.dart';
import '../module/pages/login/login_binding.dart';
import '../module/pages/login/login_page.dart';
import '../module/pages/splash_screen.dart';



class App_route{

  static const  login_pag ='/login_page';
  static const splash = '/splash';
  static const main_home_pages ='/main_home_page';
  static const home_pages ='/home_page';
  static const short_page ='/short_page';
  static const explore_page ='/explore_page';
  static const library_page ='/library_page';
  static const profile_page = '/profile_page';
  static const full_screen_media_player_page='/full_screen_media';
  static const like_page='/like_page';
  static const download_page = '/download_page';
  static const playlist_page = '/playlist_page';

  static final route=[
    GetPage(name: splash, page: ()=>splash_screen(),bindings:[ auth_binding()],middlewares: [auth_guard()]),
    GetPage(name: login_pag, page: ()=>login_page(),binding: auth_binding(),middlewares: [auth_guard()]),
    GetPage(name: main_home_pages, page: ()=>MainHomePage(),bindings: [Main_Home_Page_Binding()],middlewares: [auth_guard()]),
    GetPage(name: home_pages, page: ()=>home_page(),binding: home_binding(),middlewares: [auth_guard()]),
    GetPage(name: short_page, page: ()=>Shorts_Views(),binding: Short_Binding(),),
    GetPage(name: explore_page, page: ()=>Explore_Views(),binding: Explore_Binding(),),
    GetPage(name: library_page, page: ()=>Library_Views(),binding:Library_Binding()),
    GetPage(name: profile_page, page: ()=>Profile_Views(),binding: Profile_binding(),transition: Transition.downToUp,),
    GetPage(name: full_screen_media_player_page, page: ()=>full_screen_media_player()),
    GetPage(name: like_page, page: ()=>Like_Views(),binding: Like_Binding()),
    GetPage(name: download_page, page: ()=>Download_Views(),binding: download_binding()),
    GetPage(name: playlist_page, page: ()=>Playlist_Views(),binding: Playlist_Binding()),
  ];
}