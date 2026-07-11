// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
// import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_player_controller.dart';
// import 'package:youtube_music/module/pages/main_home_page/main_home_page_controller.dart';
// import 'package:youtube_music/module/pages/main_home_page/main_page_navigation_key.dart';
// import 'package:youtube_music/route/app_route.dart';
// import 'package:youtube_music/services/helper_code/helper_code.dart';
//
// import '../Song_search/views/search_views.dart';
//
//
//
// class MainHomePage extends StatefulWidget {
//   const MainHomePage({super.key});
//
//   @override
//   State<MainHomePage> createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
// final _controller = Get.find<Main_Home_Page_Controller>();
// final current_use_song = Get.find<get_current_song>();
//
// full_screen_media_player_controller get music_player =>
//     Get.find<full_screen_media_player_controller>();
//
// // ✅ GlobalKey so MainHomePage can call activateFocus() on SearchViews
// //    when the user taps the Search tab — this is the ONLY correct place
// //    to request keyboard focus inside an IndexedStack.
// final GlobalKey<SearchViewsState> searchKey = GlobalKey<SearchViewsState>();
//
// // Index of the search tab in the IndexedStack / BottomNavigationBar
// static const int _searchTabIndex = 1;
//
// // ─── Route generator ─────────────────────────────────────────────────────
//
// Route? Get_Page_Navigator(RouteSettings settings, List<GetPage> routes) {
//   for (final route in routes) {
//     if (route.name == settings.name) {
//       return GetPageRoute(
//         page: route.page,
//         binding: route.binding,
//         transition: route.transition,
//         middlewares: route.middlewares,
//         settings: settings,
//       );
//     }
//   }
//   return null;
// }
//
// // ─── Tab tap handler ─────────────────────────────────────────────────────
//
// void _onTabTapped(int index) {
//   _controller.get_current_index(index,searchKey);
//
//   // ✅ Only focus search bar when the user *actively* taps the search tab.
//   // We do NOT focus on initState or when the widget first mounts —
//   // that is what was causing the keyboard to auto-pop on app launch.
//   if (index == _searchTabIndex) {
//     searchKey.currentState?.activateFocus();
//   } else {
//     // Dismiss keyboard when leaving the search tab
//     FocusManager.instance.primaryFocus?.unfocus();
//   }
// }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         if (didPop) return;
//         helper_code.helper();
//       },
//       child: Scaffold(
//         body: Stack(children: [
//           Obx(
//             () => IndexedStack(
//               index: _controller.current_index.value,
//               children: [
//                 Navigator(
//                     key: navigator_key.homeNavKey,
//                     initialRoute: App_route.home_pages,
//                     onGenerateRoute: (set) =>
//                         Get_Page_Navigator(set, App_route.route)),
//                 Navigator(
//                     key: navigator_key.searchNavKey,
//                     initialRoute: App_route.search_page,
//                     onGenerateRoute: (set) =>
//                         Get_Page_Navigator(set, App_route.route)),
//                 Navigator(
//                     key: navigator_key.shortsNavKey,
//                     initialRoute: App_route.short_page,
//                     onGenerateRoute: (set) =>
//                         Get_Page_Navigator(set, App_route.route)),
//
//                 Navigator(
//                     key: navigator_key.libraryNavKey,
//                     initialRoute: App_route.library_page,
//                     onGenerateRoute: (set) =>
//                         Get_Page_Navigator(set, App_route.route)),
//               ],
//             ),
//           ),
//           Obx(
//             () => AnimatedPositioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 duration: const Duration(seconds: 3),
//                 child: AnimatedContainer(
//                   duration: const Duration(seconds: 3),
//                   color: Colors.black,
//                   child: current_use_song.current_song.value == null
//                       ? Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 5.0),
//                         child: ListTile(
//                           style: ListTileStyle.drawer,
//                           leading: Image.asset('assets/_joker1.png'),
//                           title: const Text(
//                             'nothing to play',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20),
//                           ),
//                           trailing: const Icon(
//                             Icons.play_arrow,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                       : Center(
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: 70,
//                                 child: PageView.builder(
//                                       controller: music_player.pageControllerMini,
//                                       onPageChanged: (value) {
//                                         if (value != current_use_song.currentIndex.value) {
//                                           current_use_song.currentIndex.value = value;
//                                         }
//                                       },
//                                       itemCount: current_use_song.queue.length,
//                                       itemBuilder: (context, index) {
//                                         final song = current_use_song.queue[index];
//                                         return GestureDetector(
//                                           onTap: () {
//                                             Get.toNamed(App_route
//                                                 .full_screen_media_player_page);
//                                           },
//                                           child: Container(
//                                             color: Colors.transparent,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 CachedNetworkImage(
//                                                   imageUrl:
//                                                       song.coverImage ?? '',
//                                                   height: 70,
//                                                   placeholder: (context, url) =>
//                                                       Container(
//                                                     height: 70,
//                                                     color: Colors.black,
//                                                   ),
//                                                   errorWidget: (context, url,
//                                                           error) =>
//                                                       const Icon(Icons.error),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       song.title ?? "unknown",
//                                                       style: const TextStyle(
//                                                           fontSize: 20,
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     Text(
//                                                       song.artist!
//                                                           .map((artist) =>
//                                                               artist.artistName)
//                                                           .join(','),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                       softWrap: true,
//                                                       style: const TextStyle(
//                                                           color: Colors.grey,
//                                                           fontSize: 13),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const Spacer(),
//                                                 IconButton(
//                                                   onPressed: () async {
//                                                     await music_player
//                                                         .togglePlayPause();
//                                                   },
//                                                   icon: AnimatedIcon(
//                                                     icon: AnimatedIcons
//                                                         .play_pause,
//                                                     progress: music_player
//                                                         .animationController,
//                                                   ),
//                                                   color: Colors.white,
//                                                   iconSize: 40,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//
//                               ),
//                               current_use_song.current_song.value == null
//                                   ? const SizedBox()
//                                   : SliderTheme(
//                                       data: SliderTheme.of(context).copyWith(
//                                         trackHeight:
//                                             0.5, // thin line like music apps
//                                         thumbShape:
//                                             SliderComponentShape.noThumb,
//                                         overlayShape:
//                                             const RoundSliderOverlayShape(
//                                                 overlayRadius: 0),
//                                       ),
//                                       child: Slider(
//                                         min: 0,
//                                         max: music_player.duration.value
//                                                     .inMilliseconds
//                                                     .toDouble() ==
//                                                 0
//                                             ? 1
//                                             : music_player
//                                                 .duration.value.inMilliseconds
//                                                 .toDouble(),
//                                         value: music_player
//                                             .position.value.inMilliseconds
//                                             .clamp(
//                                                 0,
//                                                 music_player.duration.value
//                                                     .inMilliseconds)
//                                             .toDouble(),
//                                         onChanged: (_) {},
//                                         activeColor: Colors.grey,
//                                         inactiveColor: Colors.black,
//                                       )),
//                             ],
//                           ),
//                         ),
//                 )),
//           ),
//         ]),
//         bottomNavigationBar: Obx(
//           () => BottomNavigationBar(
//               backgroundColor: Colors.black,
//               unselectedItemColor: Colors.white,
//               unselectedIconTheme: const IconThemeData(color: Colors.white),
//               currentIndex: _controller.current_index.value,
//               onTap: _onTabTapped,
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
//                     icon: Icon(Icons.search),
//                     activeIcon: Icon(CupertinoIcons.search),
//                     label: 'search'),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.play_arrow_outlined),
//                     activeIcon: Icon(Icons.play_arrow),
//                     label: 'short'),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_player_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/main_home_page_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/main_page_navigation_key.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../Song_search/views/search_views.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final _controller = Get.find<Main_Home_Page_Controller>();
  final current_use_song = Get.find<get_current_song>();

  full_screen_media_player_controller get music_player =>
      Get.find<full_screen_media_player_controller>();

  // ✅ GlobalKey so MainHomePage can call activateFocus() on SearchViews
  //    when the user taps the Search tab — this is the ONLY correct place
  //    to request keyboard focus inside an IndexedStack.
  final GlobalKey<SearchViewsState> searchKey = GlobalKey<SearchViewsState>();

  // Index of the search tab in the IndexedStack / BottomNavigationBar
  static const int _searchTabIndex = 1;

  // ─── Route generator ─────────────────────────────────────────────────────

  Route? Get_Page_Navigator(RouteSettings settings, List<GetPage> routes) {
    for (final route in routes) {
      if (route.name == settings.name) {
        return GetPageRoute(
          page: route.page,
          binding: route.binding,
          transition: route.transition,
          middlewares: route.middlewares,
          settings: settings,
        );
      }
    }
    return null;
  }

  // ─── Tab tap handler ─────────────────────────────────────────────────────

  void _onTabTapped(int index) {
    _controller.get_current_index(index, searchKey);

    // ✅ Only focus search bar when the user *actively* taps the search tab.
    // We do NOT focus on initState or when the widget first mounts —
    // that is what was causing the keyboard to auto-pop on app launch.
    if (index == _searchTabIndex) {
      searchKey.currentState?.activateFocus();
    } else {
      // Dismiss keyboard when leaving the search tab
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        helper_code.helper();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C14),
        body: Stack(children: [
          Obx(
            () => IndexedStack(
              index: _controller.current_index.value,
              children: [
                Navigator(
                    key: navigator_key.homeNavKey,
                    initialRoute: App_route.home_pages,
                    onGenerateRoute: (set) =>
                        Get_Page_Navigator(set, App_route.route)),
                Navigator(
                    key: navigator_key.searchNavKey,
                    initialRoute: App_route.search_page,
                    onGenerateRoute: (set) =>
                        Get_Page_Navigator(set, App_route.route)),
                Navigator(
                    key: navigator_key.shortsNavKey,
                    initialRoute: App_route.short_page,
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

          // ── Mini Player ─────────────────────────────────────────────
          Obx(
            () => AnimatedPositioned(
              left: 0,
              right: 0,
              bottom: 0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                clipBehavior: Clip.hardEdge,
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF15151F),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(

                    color: current_use_song.current_song.value == null
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFF4F46E5).withOpacity(0.30),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: current_use_song.current_song.value == null
                    ? _EmptyPlayerTile()
                    : _ActivePlayer(
                        current_use_song: current_use_song,
                        music_player: music_player,
                      ),
              ),
            ),
          ),
        ]),

        // ── Bottom Nav Bar ────────────────────────────────────────────
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C14),
              border: Border(
                top: BorderSide(
                    color: Colors.white.withOpacity(0.06), width: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isActive: _controller.current_index.value == 0,
                  onTap: () => _onTabTapped(0),
                ),
                _NavItem(
                  icon: Icons.search_rounded,
                  activeIcon: CupertinoIcons.search,
                  label: 'Search',
                  isActive: _controller.current_index.value == 1,
                  onTap: () => _onTabTapped(1),
                ),
                _NavItem(
                  icon: Icons.play_circle_outline_rounded,
                  activeIcon: Icons.play_circle_rounded,
                  label: 'Short',
                  isActive: _controller.current_index.value == 2,
                  onTap: () => _onTabTapped(2),
                ),
                _NavItem(
                  icon: Icons.library_music_outlined,
                  activeIcon: Icons.library_music_rounded,
                  label: 'Library',
                  isActive: _controller.current_index.value == 3,
                  onTap: () => _onTabTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty Player Tile ──────────────────────────────────────────────────────────

class _EmptyPlayerTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1040), Color(0xFF1E3A5F)],
              ),
            ),
            child: const Icon(Icons.music_note_rounded,
                color: Color(0xFF818CF8), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Nothing to play',
              style: TextStyle(
                color: Color(0xFFF0ECE4),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Color(0xFFF0ECE4), size: 18),
          ),
        ],
      ),
    );
  }
}

// ── Active Player (with PageView + Slider) ─────────────────────────────────────

class _ActivePlayer extends StatelessWidget {
  final get_current_song current_use_song;
  final full_screen_media_player_controller music_player;

  const _ActivePlayer({
    required this.current_use_song,
    required this.music_player,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 66,
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
                    Get.toNamed(App_route.full_screen_media_player_page);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        // Cover art
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: song.coverImage ?? '',
                            width: 50,
                            height: 50,
                            placeholder: (context, url) => Container(
                              width: 50,
                              height: 50,
                              color: const Color(0xFF1E1040),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 50,
                              height: 50,
                              color: const Color(0xFF1E1040),
                              child: const Icon(Icons.music_note_rounded,
                                  color: Color(0xFF818CF8), size: 20),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title + artist
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                song.title ?? 'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFF0ECE4),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                song.artist
                                        ?.map((a) => a.artistName)
                                        .join(', ') ??
                                    '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyle(
                                  color:
                                      const Color(0xFFF0ECE4).withOpacity(0.40),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Play/pause
                        GestureDetector(
                          onTap: () async {
                            await music_player.togglePlayPause();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                              ),
                            ),
                            child: Center(
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: music_player.animationController,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Progress bar ────────────────────────────────────────────
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.5,
              thumbShape: SliderComponentShape.noThumb,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            ),
            child: Slider(
              min: 0,
              max: music_player.duration.value.inMilliseconds.toDouble() == 0
                  ? 1
                  : music_player.duration.value.inMilliseconds.toDouble(),
              value: music_player.position.value.inMilliseconds
                  .clamp(0, music_player.duration.value.inMilliseconds)
                  .toDouble(),
              onChanged: (_) {},
              activeColor: Colors.white,
              inactiveColor: Colors.white.withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav Item ────────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF818CF8) : const Color(0x4DF0ECE4);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
