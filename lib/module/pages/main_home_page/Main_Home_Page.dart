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
final GlobalKey<SearchViewsState> _searchKey = GlobalKey<SearchViewsState>();

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
  _controller.get_current_index(index);

  // ✅ Only focus search bar when the user *actively* taps the search tab.
  // We do NOT focus on initState or when the widget first mounts —
  // that is what was causing the keyboard to auto-pop on app launch.
  if (index == _searchTabIndex) {
    _searchKey.currentState?.activateFocus();
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
              currentIndex: _controller.current_index.value,
              onTap: _onTabTapped,
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
                    icon: Icon(Icons.search),
                    activeIcon: Icon(CupertinoIcons.search),
                    label: 'search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.play_arrow_outlined),
                    activeIcon: Icon(Icons.play_arrow),
                    label: 'short'),
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
