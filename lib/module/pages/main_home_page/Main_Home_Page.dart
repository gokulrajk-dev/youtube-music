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

// current buttom Navigation code
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
              child: Column(
                children: [
                  AnimatedContainer(
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
                  Container(
                    height: 70,
                    width: 270,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _PillItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          selected: _controller.current_index.value == 0,
                          onTap: () => _onTabTapped(0),
                        ),
                        _PillItem(
                          icon: CupertinoIcons.search,
                          activeIcon: CupertinoIcons.search,
                          selected: _controller.current_index.value == 1,
                          onTap: () => _onTabTapped(1),
                        ), _PillItem(
                          icon: Icons.play_circle_outline_rounded,
                          activeIcon: Icons.play_circle_rounded,
                          selected: _controller.current_index.value == 2,
                          onTap: () => _onTabTapped(2),
                        ),
                        _PillItem(
                          icon: Icons.library_music_outlined,
                          activeIcon: Icons.library_music_rounded,
                          selected: _controller.current_index.value == 3,
                          onTap: () => _onTabTapped(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),

        // ── Bottom Nav Bar ────────────────────────────────────────────
        // bottomNavigationBar: Obx(
        //   () => Container(
        //     decoration: BoxDecoration(
        //       color: const Color(0xFF0C0C14),
        //       border: Border(
        //         top: BorderSide(
        //             color: Colors.white.withOpacity(0.06), width: 0.5),
        //       ),
        //     ),
        //     padding: const EdgeInsets.symmetric(vertical: 8),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         _NavItem(
        //           icon: Icons.home_outlined,
        //           activeIcon: Icons.home_rounded,
        //           label: 'Home',
        //           isActive: _controller.current_index.value == 0,
        //           onTap: () => _onTabTapped(0),
        //         ),
        //         _NavItem(
        //           icon: Icons.search_rounded,
        //           activeIcon: CupertinoIcons.search,
        //           label: 'Search',
        //           isActive: _controller.current_index.value == 1,
        //           onTap: () => _onTabTapped(1),
        //         ),
        //         _NavItem(
        //           icon: Icons.play_circle_outline_rounded,
        //           activeIcon: Icons.play_circle_rounded,
        //           label: 'Short',
        //           isActive: _controller.current_index.value == 2,
        //           onTap: () => _onTabTapped(2),
        //         ),
        //         _NavItem(
        //           icon: Icons.library_music_outlined,
        //           activeIcon: Icons.library_music_rounded,
        //           label: 'Library',
        //           isActive: _controller.current_index.value == 3,
        //           onTap: () => _onTabTapped(3),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final VoidCallback onTap;

  const _PillItem({
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? Colors.white.withOpacity(0.25) : Colors.transparent,
        ),
        child: Icon(
          selected ? activeIcon : icon,
          color: Colors.white,
          size: 26,
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

//
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
// class MainHomePage extends StatefulWidget {
//   const MainHomePage({super.key});
//
//   @override
//   State<MainHomePage> createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
//   final _controller = Get.find<Main_Home_Page_Controller>();
//   final current_use_song = Get.find<get_current_song>();
//
//   full_screen_media_player_controller get music_player =>
//       Get.find<full_screen_media_player_controller>();
//
//   // ✅ GlobalKey so MainHomePage can call activateFocus() on SearchViews
//   //    when the user taps the Search tab — this is the ONLY correct place
//   //    to request keyboard focus inside an IndexedStack.
//   final GlobalKey<SearchViewsState> searchKey = GlobalKey<SearchViewsState>();
//
//   // Index of the search tab in the IndexedStack / BottomNavigationBar
//   static const int _searchTabIndex = 1;
//
//   // ─── Route generator ─────────────────────────────────────────────────────
//
//   Route? Get_Page_Navigator(RouteSettings settings, List<GetPage> routes) {
//     for (final route in routes) {
//       if (route.name == settings.name) {
//         return GetPageRoute(
//           page: route.page,
//           binding: route.binding,
//           transition: route.transition,
//           middlewares: route.middlewares,
//           settings: settings,
//         );
//       }
//     }
//     return null;
//   }
//
//   // ─── Tab tap handler ─────────────────────────────────────────────────────
//
//   void _onTabTapped(int index) {
//     _controller.get_current_index(index, searchKey);
//
//     // ✅ Only focus search bar when the user *actively* taps the search tab.
//     // We do NOT focus on initState or when the widget first mounts —
//     // that is what was causing the keyboard to auto-pop on app launch.
//     if (index == _searchTabIndex) {
//       searchKey.currentState?.activateFocus();
//     } else {
//       // Dismiss keyboard when leaving the search tab
//       FocusManager.instance.primaryFocus?.unfocus();
//     }
//   }
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
//         backgroundColor: const Color(0xFF0C0C14),
//         // ✅ No bottomNavigationBar property anymore — everything now
//         // lives inside the Stack so the mini player and nav bar can be
//         // stacked together as one floating unit.
//         body: Stack(
//           children: [
//             Obx(
//                   () => IndexedStack(
//                 index: _controller.current_index.value,
//                 children: [
//                   Navigator(
//                       key: navigator_key.homeNavKey,
//                       initialRoute: App_route.home_pages,
//                       onGenerateRoute: (set) =>
//                           Get_Page_Navigator(set, App_route.route)),
//                   Navigator(
//                       key: navigator_key.searchNavKey,
//                       initialRoute: App_route.search_page,
//                       onGenerateRoute: (set) =>
//                           Get_Page_Navigator(set, App_route.route)),
//                   Navigator(
//                       key: navigator_key.shortsNavKey,
//                       initialRoute: App_route.short_page,
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
//
//             // ── Mini Player + Liquid Nav Bar (stacked together) ───────
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // ── Mini Player ───────────────────────────────────
//                   Obx(
//                         () => AnimatedContainer(
//                       clipBehavior: Clip.hardEdge,
//                       duration: const Duration(milliseconds: 400),
//                       curve: Curves.easeOutCubic,
//                       margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF15151F),
//                         borderRadius: BorderRadius.circular(18),
//                         border: Border.all(
//                           color: current_use_song.current_song.value == null
//                               ? Colors.white.withOpacity(0.06)
//                               : const Color(0xFF4F46E5).withOpacity(0.30),
//                           width: 0.5,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.35),
//                             blurRadius: 18,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: current_use_song.current_song.value == null
//                           ? _EmptyPlayerTile()
//                           : _ActivePlayer(
//                         current_use_song: current_use_song,
//                         music_player: music_player,
//                       ),
//                     ),
//                   ),
//
//                   // ── Liquid Nav Bar ────────────────────────────────
//                   Obx(
//                         () => _LiquidNavBar(
//                       currentIndex: _controller.current_index.value,
//                       onTap: _onTabTapped,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Empty Player Tile ──────────────────────────────────────────────────────────
//
// class _EmptyPlayerTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF1E1040), Color(0xFF1E3A5F)],
//               ),
//             ),
//             child: const Icon(Icons.music_note_rounded,
//                 color: Color(0xFF818CF8), size: 20),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Text(
//               'Nothing to play',
//               style: TextStyle(
//                 color: Color(0xFFF0ECE4),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withOpacity(0.06),
//             ),
//             child: const Icon(Icons.play_arrow_rounded,
//                 color: Color(0xFFF0ECE4), size: 18),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Active Player (with PageView + Slider) ─────────────────────────────────────
//
// class _ActivePlayer extends StatelessWidget {
//   final get_current_song current_use_song;
//   final full_screen_media_player_controller music_player;
//
//   const _ActivePlayer({
//     required this.current_use_song,
//     required this.music_player,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//           () => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             height: 66,
//             child: PageView.builder(
//               controller: music_player.pageControllerMini,
//               onPageChanged: (value) {
//                 if (value != current_use_song.currentIndex.value) {
//                   current_use_song.currentIndex.value = value;
//                 }
//               },
//               itemCount: current_use_song.queue.length,
//               itemBuilder: (context, index) {
//                 final song = current_use_song.queue[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Get.toNamed(App_route.full_screen_media_player_page);
//                   },
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                     color: Colors.transparent,
//                     child: Row(
//                       children: [
//                         // Cover art
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: CachedNetworkImage(
//                             imageUrl: song.coverImage ?? '',
//                             width: 50,
//                             height: 50,
//                             placeholder: (context, url) => Container(
//                               width: 50,
//                               height: 50,
//                               color: const Color(0xFF1E1040),
//                             ),
//                             errorWidget: (context, url, error) => Container(
//                               width: 50,
//                               height: 50,
//                               color: const Color(0xFF1E1040),
//                               child: const Icon(Icons.music_note_rounded,
//                                   color: Color(0xFF818CF8), size: 20),
//                             ),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//
//                         // Title + artist
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 song.title ?? 'Unknown',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFFF0ECE4),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 song.artist
//                                     ?.map((a) => a.artistName)
//                                     .join(', ') ??
//                                     '',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 softWrap: true,
//                                 style: TextStyle(
//                                   color:
//                                   const Color(0xFFF0ECE4).withOpacity(0.40),
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Play/pause
//                         GestureDetector(
//                           onTap: () async {
//                             await music_player.togglePlayPause();
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
//                               ),
//                             ),
//                             child: Center(
//                               child: AnimatedIcon(
//                                 icon: AnimatedIcons.play_pause,
//                                 progress: music_player.animationController,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // ── Progress bar ────────────────────────────────────────────
//           SliderTheme(
//             data: SliderTheme.of(context).copyWith(
//               trackHeight: 2.5,
//               thumbShape: SliderComponentShape.noThumb,
//               overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
//             ),
//             child: Slider(
//               min: 0,
//               max: music_player.duration.value.inMilliseconds.toDouble() == 0
//                   ? 1
//                   : music_player.duration.value.inMilliseconds.toDouble(),
//               value: music_player.position.value.inMilliseconds
//                   .clamp(0, music_player.duration.value.inMilliseconds)
//                   .toDouble(),
//               onChanged: (_) {},
//               activeColor: Colors.white,
//               inactiveColor: Colors.white.withOpacity(0.08),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Liquid Nav Bar ───────────────────────────────────────────────────────────────
// //
// // A floating pill bar with:
// //  • A jagged "hedge cut" top edge (zig-zag clip) instead of a flat rectangle
// //  • A slowly shifting liquid gradient background (animated Alignment)
// //  • 4 nav items: Home / Search / Short / Library
// //
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _LiquidNavBar extends StatefulWidget {
//   final int currentIndex;
//   final void Function(int) onTap;
//
//   const _LiquidNavBar({
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   @override
//   State<_LiquidNavBar> createState() => _LiquidNavBarState();
// }
//
// class _LiquidNavBarState extends State<_LiquidNavBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _liquidController;
//
//   @override
//   void initState() {
//     super.initState();
//     _liquidController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _liquidController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _liquidController,
//       builder: (context, child) {
//         final t = _liquidController.value; // 0 → 1 → 0 loop
//
//         return ClipPath(
//           child: Container(
//             height: 76,
//             margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(-1 + t * 2, -1),
//                 end: Alignment(1 - t * 2, 1),
//                 colors: const [
//                   Color(0xFF4F46E5), // indigo
//                   Color(0xFF9333EA), // violet
//                   Color(0xFFDB2777), // pink
//                   Color(0xFFF97316), // orange pop
//                 ],
//                 stops: const [0.0, 0.4, 0.75, 1.0],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF9333EA).withOpacity(0.35),
//                   blurRadius: 24,
//                   offset: const Offset(0, -6),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 18, bottom: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _LiquidNavItem(
//                     icon: Icons.home_outlined,
//                     activeIcon: Icons.home_rounded,
//                     label: 'Home',
//                     selected: widget.currentIndex == 0,
//                     onTap: () => widget.onTap(0),
//                   ),
//                   _LiquidNavItem(
//                     icon: CupertinoIcons.search,
//                     activeIcon: CupertinoIcons.search,
//                     label: 'Search',
//                     selected: widget.currentIndex == 1,
//                     onTap: () => widget.onTap(1),
//                   ),
//                   _LiquidNavItem(
//                     icon: Icons.play_circle_outline_rounded,
//                     activeIcon: Icons.play_circle_rounded,
//                     label: 'Short',
//                     selected: widget.currentIndex == 2,
//                     onTap: () => widget.onTap(2),
//                   ),
//                   _LiquidNavItem(
//                     icon: Icons.library_music_outlined,
//                     activeIcon: Icons.library_music_rounded,
//                     label: 'Library',
//                     selected: widget.currentIndex == 3,
//                     onTap: () => widget.onTap(3),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // ── Hedge-cut clipper: zig-zag "hedge trim" top edge ────────────────────────────
//
// class _HedgeCutClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     const notchCount = 7;
//     final segmentWidth = size.width / notchCount;
//     const notchDepth = 10.0;
//
//     path.moveTo(0, notchDepth);
//     for (int i = 0; i < notchCount; i++) {
//       final xStart = i * segmentWidth;
//       final xMid = xStart + segmentWidth / 2;
//       final xEnd = xStart + segmentWidth;
//       path.quadraticBezierTo(xMid, 0, xEnd, notchDepth);
//     }
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }
//
// // ── Nav Item (icon + label, used inside the liquid bar) ─────────────────────────
//
// class _LiquidNavItem extends StatelessWidget {
//   final IconData icon;
//   final IconData activeIcon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const _LiquidNavItem({
//     required this.icon,
//     required this.activeIcon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedScale(
//         scale: selected ? 1.08 : 1.0,
//         duration: const Duration(milliseconds: 220),
//         curve: Curves.easeOutBack,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: selected ? Colors.white.withOpacity(0.22) : Colors.transparent,
//               ),
//               child: Icon(
//                 selected ? activeIcon : icon,
//                 color: selected ? Colors.white : Colors.white.withOpacity(0.55),
//                 size: 22,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.2,
//                 color: selected ? Colors.white : Colors.white.withOpacity(0.50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
