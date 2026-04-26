import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_player_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/main_home_page_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/main_page_navigation_key.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

// class MainHomePage extends StatefulWidget {
//   const MainHomePage({super.key});
//
//   @override
//   State<MainHomePage> createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(initialIndex:0,length: 4, child: Scaffold(
//       appBar: AppBar(
//         title: Text('music'),
//         bottom: TabBar(tabs: [
//           Tab(text: 'for you',),Tab(text: 'for you',),Tab(text: 'for you',),Tab(text: 'for you',),
//         ]),
//       ),
//       body: TabBarView(children: [
//         home_page(),
//         Shorts_Views(),
//         Explore_Views(),
//         Library_Views()
//       ]),
//     ));
//   }
// }

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final controller = Get.find<Main_Home_Page_Controller>();
  final current_use_song = Get.find<get_current_song>();
  final helper_code help = helper_code();

  full_screen_media_player_controller get music_player =>
      Get.find<full_screen_media_player_controller>();

  @override
  void initState() {
    super.initState();
  }

  Route? Get_Page_Navigator(RouteSettings setting, List<GetPage> routes) {
    for (var route in routes) {
      if (route.name == setting.name) {
        return GetPageRoute(
          page: route.page,
          binding: route.binding,
          transition: route.transition,
          middlewares: route.middlewares,
          settings: setting,
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        help.helper();
      },
      child: Scaffold(
        body: Stack(children: [
          Obx(
            () => IndexedStack(
              index: controller.current_index.value,
              children: [
                Navigator(
                    key: navigator_key.homeNavKey,
                    initialRoute: App_route.home_pages,
                    onGenerateRoute: (set) =>
                        Get_Page_Navigator(set, App_route.route)),
                // home_page(),
                Navigator(
                    key: navigator_key.shortsNavKey,
                    initialRoute: App_route.short_page,
                    onGenerateRoute: (set) =>
                        Get_Page_Navigator(set, App_route.route)),
                Navigator(
                    key: navigator_key.exploreNavKey,
                    initialRoute: App_route.explore_page,
                    onGenerateRoute: (set) =>
                        Get_Page_Navigator(set, App_route.route)),
                Navigator(
                    key: navigator_key.libraryNavKey,
                    initialRoute: App_route.library_page,
                    onGenerateRoute: (set) =>
                        Get_Page_Navigator(set, App_route.route)),
              ],
            ),
          ),
          Obx(
            () => AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: 0,
                duration: const Duration(seconds: 3),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  color: Colors.black,
                  child: current_use_song.current_song.value == null
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          style: ListTileStyle.drawer,
                          leading: Image.asset('assets/_joker1.png'),
                          title: const Text(
                            'nothing to play',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          trailing: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      )
                      : Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 70,
                                child: PageView.builder(
                                      controller: music_player.pageControllerMini,
                                      onPageChanged: (value) {
                                        if (value != current_use_song.currentIndex.value) {
                                          current_use_song.currentIndex.value = value;
                                        }
                                      },
                                      itemCount: current_use_song.queue.length,
                                      itemBuilder: (context, index) {
                                        final song = current_use_song.queue[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.toNamed(App_route
                                                .full_screen_media_player_page);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      song.coverImage ?? '',
                                                  height: 70,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 70,
                                                    color: Colors.black,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      song.title ?? "unknown",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      song.artist!
                                                          .map((artist) =>
                                                              artist.artistName)
                                                          .join(','),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  onPressed: () async {
                                                    await music_player
                                                        .togglePlayPause();
                                                  },
                                                  icon: AnimatedIcon(
                                                    icon: AnimatedIcons
                                                        .play_pause,
                                                    progress: music_player
                                                        .animationController,
                                                  ),
                                                  color: Colors.white,
                                                  iconSize: 40,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                              ),
                              current_use_song.current_song.value == null
                                  ? const SizedBox()
                                  : SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight:
                                            0.5, // thin line like music apps
                                        thumbShape:
                                            SliderComponentShape.noThumb,
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 0),
                                      ),
                                      child: Slider(
                                        min: 0,
                                        max: music_player.duration.value
                                                    .inMilliseconds
                                                    .toDouble() ==
                                                0
                                            ? 1
                                            : music_player
                                                .duration.value.inMilliseconds
                                                .toDouble(),
                                        value: music_player
                                            .position.value.inMilliseconds
                                            .clamp(
                                                0,
                                                music_player.duration.value
                                                    .inMilliseconds)
                                            .toDouble(),
                                        onChanged: (_) {},
                                        activeColor: Colors.grey,
                                        inactiveColor: Colors.black,
                                      )),
                            ],
                          ),
                        ),
                )),
          ),
        ]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              backgroundColor: Colors.black,
              unselectedItemColor: Colors.white,
              unselectedIconTheme: const IconThemeData(color: Colors.white),
              currentIndex: controller.current_index.value,
              onTap: controller.get_current_index,
              selectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    label: 'home',
                    activeIcon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.play_arrow_outlined),
                    activeIcon: Icon(Icons.play_arrow),
                    label: 'short'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.explore_outlined,
                    ),
                    activeIcon: Icon(Icons.explore),
                    label: 'explore'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.my_library_music_outlined),
                    activeIcon: Icon(Icons.my_library_music),
                    label: 'library'),
              ]),
        ),
      ),
    );
  }
}

//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
// import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_media_player.dart';
// import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_player_controller.dart';
// import 'package:youtube_music/module/pages/main_home_page/main_home_page_controller.dart';
// import 'package:youtube_music/module/pages/main_home_page/main_page_navigation_key.dart';
// import 'package:youtube_music/route/app_route.dart';
// import 'package:youtube_music/services/helper_code/helper_code.dart';
//
// // class MainHomePage extends StatefulWidget {
// //   const MainHomePage({super.key});
// //
// //   @override
// //   State<MainHomePage> createState() => _MainHomePageState();
// // }
// //
// // class _MainHomePageState extends State<MainHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(initialIndex:0,length: 4, child: Scaffold(
// //       appBar: AppBar(
// //         title: Text('music'),
// //         bottom: TabBar(tabs: [
// //           Tab(text: 'for you',),Tab(text: 'for you',),Tab(text: 'for you',),Tab(text: 'for you',),
// //         ]),
// //       ),
// //       body: TabBarView(children: [
// //         home_page(),
// //         Shorts_Views(),
// //         Explore_Views(),
// //         Library_Views()
// //       ]),
// //     ));
// //   }
// // }
//
// class MainHomePage extends StatefulWidget {
//   const MainHomePage({super.key});
//
//   @override
//   State<MainHomePage> createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
//   final controller = Get.find<Main_Home_Page_Controller>();
//   final current_use_song = Get.find<get_current_song>();
//   final helper_code help = helper_code();
//
//   full_screen_media_player_controller get music_player =>
//       Get.find<full_screen_media_player_controller>();
//   double minHeight = 70;
//   double maxHeight = 0;
//   double currentHeight = 70;
//
//   Route? Get_Page_Navigator(RouteSettings setting, List<GetPage> routes) {
//     for (var route in routes) {
//       if (route.name == setting.name) {
//         return GetPageRoute(
//           page: route.page,
//           binding: route.binding,
//           transition: route.transition,
//           middlewares: route.middlewares,
//           settings: setting,
//         );
//       }
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (did_pop) {
//         if (did_pop) return;
//         help.helper();
//       },
//       child: Scaffold(
//         body: LayoutBuilder(builder: (context, constraints) {
//           maxHeight = constraints.maxHeight;
//
//           return Stack(children: [
//             Obx(
//               () => IndexedStack(
//                 index: controller.current_index.value,
//                 children: [
//                   Navigator(
//                       key: navigator_key.homeNavKey,
//                       initialRoute: App_route.home_pages,
//                       onGenerateRoute: (set) =>
//                           Get_Page_Navigator(set, App_route.route)),
//                   // home_page(),
//                   Navigator(
//                       key: navigator_key.shortsNavKey,
//                       initialRoute: App_route.short_page,
//                       onGenerateRoute: (set) =>
//                           Get_Page_Navigator(set, App_route.route)),
//                   Navigator(
//                       key: navigator_key.exploreNavKey,
//                       initialRoute: App_route.explore_page,
//                       onGenerateRoute: (set) =>
//                           Get_Page_Navigator(set, App_route.route)),
//                   Navigator(
//                       key: navigator_key.libraryNavKey,
//                       initialRoute: App_route.library_page,
//                       onGenerateRoute: (set) =>
//                           Get_Page_Navigator(set, App_route.route)),
//                 ],
//               ),
//             ),
//             Obx(
//               () => AnimatedPositioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   duration: const Duration(seconds: 3),
//                   child: AnimatedContainer(
//                     duration: Duration(seconds: 5),
//                     curve: Curves.easeInOut,
//                     height: currentHeight,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: currentHeight == minHeight
//                           ? BorderRadius.zero
//                           : BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child:currentHeight ==minHeight
//                     ?current_use_song.current_song.value == null
//                         ? Center(
//                             child: ListTile(
//                               style: ListTileStyle.drawer,
//                               leading: Image.asset('assets/_joker1.png'),
//                               title: const Text(
//                                 'nothing to play',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20),
//                               ),
//                               trailing: const Icon(
//                                 Icons.play_arrow,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           )
//                         : Center(
//                             child: ListTile(
//                               onTap: () {
//                                 // Get.toNamed(
//                                 //     App_route.full_screen_media_player_page);
//                               },
//                               style: ListTileStyle.drawer,
//                               leading: Image.network(current_use_song
//                                       .current_song.value!.coverImage ??
//                                   ""),
//                               titleAlignment: ListTileTitleAlignment.center,
//                               title: Text(
//                                 current_use_song.current_song.value!.title ??
//                                     'unknown',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20),
//                               ),
//                               subtitle: Text(
//                                 current_use_song.current_song.value!.artist!
//                                     .map((artist) => artist.artistName)
//                                     .join(','),
//                                 style: const TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                                 softWrap: true,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               trailing: IconButton(
//                                 onPressed: () async {
//                                   music_player.contorller_for_song();
//                                 },
//                                 icon: AnimatedIcon(
//                                   icon: AnimatedIcons.play_pause,
//                                   progress: music_player.animationController,
//                                 ),
//                                 color: Colors.white,
//                                 iconSize: 35,
//                               ),
//                             ),
//                           ):full_screen_media_player(),
//                   )),
//             )
//           ]);
//         }),
//         bottomNavigationBar: Obx(
//           () => BottomNavigationBar(
//               backgroundColor: Colors.black,
//               unselectedItemColor: Colors.white,
//               unselectedIconTheme: const IconThemeData(color: Colors.white),
//               currentIndex: controller.current_index.value,
//               onTap: controller.get_current_index,
//               selectedItemColor: Colors.white,
//               type: BottomNavigationBarType.fixed,
//               items: const [
//                 BottomNavigationBarItem(
//                     icon: Icon(
//                       Icons.home_outlined,
//                     ),
//                     label: 'home',
//                     activeIcon: Icon(Icons.home)),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.play_arrow_outlined),
//                     activeIcon: Icon(Icons.play_arrow),
//                     label: 'short'),
//                 BottomNavigationBarItem(
//                     icon: Icon(
//                       Icons.explore_outlined,
//                     ),
//                     activeIcon: Icon(Icons.explore),
//                     label: 'explore'),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.my_library_music_outlined),
//                     activeIcon: Icon(Icons.my_library_music),
//                     label: 'library'),
//               ]),
//         ),
//       ),
//     );
//   }
// }
