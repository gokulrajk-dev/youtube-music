import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
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
      onPopInvoked: (didpop) {
        if (didpop) return;
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
                      ? Center(
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
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(
                                  App_route.full_screen_media_player_page);
                            },
                            style: ListTileStyle.drawer,
                            leading: Image.network(current_use_song
                                .current_song.value!.coverImage),
                            titleAlignment: ListTileTitleAlignment.center,
                            title: Text(
                              current_use_song.current_song.value!.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            subtitle: Text(
                              current_use_song.current_song.value!.artist
                                  .map((artist) => artist.artistName)
                                  .join(','),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                )),
          )
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
