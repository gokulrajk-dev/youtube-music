// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:youtube_music/core/action/action_context.dart';
// import 'package:youtube_music/module/pages/Album/album_controller.dart';
// import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
// import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';
// import 'package:youtube_music/route/app_route.dart';
//
// import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
// import '../like_page/like_controller.dart';
// import '../main_home_page/main_home_page_controller.dart';
// import 'controllers/all_song_controller.dart';
//
// class home_page extends StatefulWidget {
//   const home_page({super.key});
//
//   @override
//   State<home_page> createState() => _home_pageState();
// }
//
// class _home_pageState extends State<home_page> {
//   final Main_Home_Page_Controller main_home =
//       Get.find<Main_Home_Page_Controller>();
//   final user_details_controller controller =
//       Get.find<user_details_controller>();
//   final get_all_song_controller controller_song =
//       Get.find<get_all_song_controller>();
//   final get_current_song pick_current_song = Get.find<get_current_song>();
//   final Like_Controller like = Get.find<Like_Controller>();
//   final Album_Controller album_song = Get.find<Album_Controller>();
//   final Artist_Controller artist_song = Get.find<Artist_Controller>();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: RefreshIndicator(
//           color: Colors.red,
//           displacement: 100,
//           backgroundColor: Colors.black,
//           onRefresh: () async {
//             await main_home.refreshHome([
//               controller.fetch_user(),
//               controller_song.get_all_songs(),
//               controller_song.get_all_Genre(),
//               like.get_current_user_like_songs(),
//               album_song.get_song_album(),
//               artist_song.get_full_aritist_list(),
//             ]);
//           },
//           child: CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 // expandedHeight: 300,
//                 // flexibleSpace: FlexibleSpaceBar(
//                 //   collapseMode: CollapseMode.parallax,
//                 //   background: Stack(
//                 //     fit: StackFit.loose,
//                 //     children: [
//                 //       Image.asset('assets/_joker1.png'),
//                 //       Container(
//                 //         color: Colors.black.withOpacity(0.4),
//                 //       )
//                 //     ],
//                 //   ),
//                 // ),
//                 leading: TextButton.icon(
//                   onPressed: () {},
//                   label: const Text(
//                     'MUSIC',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                   icon: const Icon(
//                     Icons.play_circle_outline,
//                     color: Colors.red,
//                   ),
//                 ),
//                 leadingWidth: 110,
//                 floating: true,
//                 actions: [
//                   IconButton(
//                     onPressed: () {
//                       Get.toNamed(App_route.history_page, id: 1);
//                     },
//                     icon: const Icon(Icons.history),
//                     color: Colors.black,
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.notifications_none),
//                     color: Colors.black,
//                   ),
//                   // IconButton(
//                   //   onPressed: () {
//                   //     final main = Get.find<Main_Home_Page_Controller>();
//                   //     final helper = NavHelper.getNavId(main.current_index.value);
//                   //     Get.toNamed(App_route.search_page,id: helper);
//                   //   },
//                   //   icon: const Icon(Icons.search),
//                   //   color: Colors.black,
//                   // ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.toNamed(App_route.profile_page);
//                     },
//                     child: Obx(() {
//                       final user = controller.user.value;
//                       return user == null
//                           ? const CircleAvatar(
//                               backgroundImage: AssetImage('assets/_joker1.png'),
//                             )
//                           : CircleAvatar(
//                               backgroundImage: NetworkImage(user.photoUrl),
//                             );
//                     }),
//                   )
//                 ],
//               ),
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: pinnedHeaderDelegate(
//                   height: 50,
//                   child: SizedBox(
//                     height: 100,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Obx(
//                         ()=> ListView.builder(
//                           shrinkWrap: true,
//                           physics: const BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           itemCount: controller_song.genres.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final genreName = controller_song.genres[index];
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 8),
//                               child: Chip(
//                                 label: Text("${genreName.genreName}"),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Text(
//                     "Quick Picks",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               // profile
//               // SliverToBoxAdapter(
//               //   child: Obx(() {
//               //     if (controller.isloading.value) {
//               //       return const Center(
//               //         child: CircularProgressIndicator(),
//               //       );
//               //     }
//               //     if (controller.error.isNotEmpty) {
//               //       return Center(
//               //         child: Text(controller.error.value),
//               //       );
//               //     }
//               //     if (controller.user.value == null) {
//               //       return const Center(
//               //         child: Text('no'),
//               //       );
//               //     }
//               //
//               //     final user = controller.user.value!;
//               //
//               //     return Padding(
//               //       padding: const EdgeInsets.all(16),
//               //       child: Column(
//               //         children: [
//               //           // CircleAvatar(
//               //           //   radius: 50,
//               //           //   backgroundImage: NetworkImage(user.photoUrl),
//               //           // ),
//               //           const SizedBox(height: 16),
//               //           Text(
//               //             user.userName,
//               //             style: const TextStyle(
//               //               fontSize: 22,
//               //               fontWeight: FontWeight.bold,
//               //             ),
//               //           ),
//               //           const SizedBox(height: 8),
//               //           Text(user.gmail),
//               //           const SizedBox(height: 8),
//               //           Text('Phone: ${user.phoneNumber}'),
//               //         ],
//               //       ),
//               //     );
//               //   }),
//               // ),
//
//               // SliverList(
//               //   delegate: SliverChildBuilderDelegate(
//               //     (context, index) => ListTile(
//               //       leading: const Icon(Icons.music_note),
//               //       title: Text("Song $index"),
//               //       subtitle: const Text("Artist"),
//               //       trailing: const Icon(Icons.more_vert),
//               //     ),
//               //     childCount: 20,
//               //   ),
//               // ),
//               // SliverAnimatedGrid(
//               //   key: _gridKey,
//               //   initialItemCount: 4,
//               //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               //     crossAxisCount: 2,
//               //     mainAxisSpacing: 12,
//               //     crossAxisSpacing: 12,
//               //     childAspectRatio: 1,
//               //   ),
//               //   itemBuilder: (context, index, animation) {
//               //     return FadeTransition(
//               //       opacity: animation,
//               //       child: ListTile(
//               //         title: Text('$index'),
//               //       )
//               //     );
//               //   },
//               // ),
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                     height: 100,
//                     child: Obx(() {
//                       if (controller_song.is_loading.value) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//
//                       if (controller_song.songs.isEmpty) {
//                         return const Center(child: Text('No songs available'));
//                       }
//
//                       return PageView.builder(
//                         itemCount: controller_song.songs.length,
//                         controller: PageController(viewportFraction: 1),
//                         itemBuilder: (context, index) {
//                           final song = controller_song.songs[index];
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 pick_current_song.autoSongType(song, 0);
//                                 Get.toNamed(
//                                   App_route.full_screen_media_player_page,
//                                 );
//                               },
//                               // onLongPress: () {
//                               //   Get.bottomSheet(
//                               //     elevation: 5,
//                               //     DraggableScrollableSheet(
//                               //       expand: false,
//                               //       builder: (context, scrollController) {
//                               //         return globle_bottom_sheet(
//                               //           controllers: scrollController,
//                               //           song: song,
//                               //           type: "mainpage",
//                               //         );
//                               //       },
//                               //     ),
//                               //     isScrollControlled: true,
//                               //   );
//                               // },
//                               onLongPress: () {
//                                 Get.bottomSheet(
//                                   elevation: 5,
//                                   DraggableScrollableSheet(builder:
//                                       (BuildContext context,
//                                           ScrollController scrollController) {
//                                     return ContextBottomSheet(
//                                         controllers: scrollController,
//                                         context: ActionContext(
//                                             entityType: EntityType.song,
//                                             entity: song,
//                                             page: PageContext.home,
//                                             isOwner: true,
//                                             isSaved: false));
//                                   }),
//                                   isScrollControlled: true,
//                                 );
//                               },
//                               child: Container(
//                                 color: Colors.transparent,
//                                 child: Row(
//                                   children: [
//                                     CachedNetworkImage(
//                                       imageUrl: song.coverImage ?? '',
//                                       height: 70,
//                                       placeholder: (context, url) => Container(
//                                         height: 70,
//                                         color: Colors.black,
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           const Icon(Icons.error),
//                                       fit: BoxFit.cover,
//                                     ),
//                                     const Spacer(),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           song.title ?? "unknown",
//                                           style: const TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           song.artist!
//                                               .map(
//                                                   (artist) => artist.artistName)
//                                               .join(','),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                           softWrap: true,
//                                           style: const TextStyle(
//                                               color: Colors.grey, fontSize: 13),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     IconButton(
//                                         onPressed: () {
//                                           Get.bottomSheet(
//                                             elevation: 5,
//                                             DraggableScrollableSheet(builder:
//                                                 (BuildContext context,
//                                                     ScrollController
//                                                         scrollController) {
//                                               return ContextBottomSheet(
//                                                   controllers: scrollController,
//                                                   context: ActionContext(
//                                                       entityType:
//                                                           EntityType.song,
//                                                       entity: song,
//                                                       page: PageContext.home,
//                                                       isOwner: true,
//                                                       isSaved: false));
//                                             }),
//                                             isScrollControlled: true,
//                                           );
//                                         },
//                                         icon: const Icon(
//                                           Icons.more_vert,
//                                           color: Colors.black,
//                                         ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     })),
//               ),
//
//               const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Text(
//                     "Quick Picks Album",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8.0, bottom: 10),
//                   child: SizedBox(
//                     height: 225,
//                     child: Obx(
//                       () => SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: album_song.album_song.map((album) {
//                             return album.songAlbum!.isEmpty
//                                 ? const SizedBox()
//                                 : GestureDetector(
//                                     onLongPress: () {
//                                       Get.bottomSheet(
//                                         elevation: 5,
//                                         DraggableScrollableSheet(builder:
//                                             (BuildContext context,
//                                                 ScrollController
//                                                     scrollController) {
//                                           return ContextBottomSheet(
//                                               controllers: scrollController,
//                                               context: ActionContext(
//                                                   entityType: EntityType.album,
//                                                   entity: album,
//                                                   page: PageContext.home,
//                                                   isOwner: false,
//                                                   isSaved: false));
//                                         }),
//                                         isScrollControlled: true,
//                                       );
//                                     },
//                                     onTap: () async {
//                                       await album_song
//                                           .retrive_album_song_con(album.id);
//                                       Get.toNamed(App_route.album_page, id: 1);
//                                     },
//                                     child: Container(
//                                       width: 160,
//                                       color: Colors.transparent,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 8.0, right: 8),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               clipBehavior: Clip.hardEdge,
//                                               width: 150,
//                                               height: 150,
//                                               // margin: const EdgeInsets.symmetric(horizontal: 8),
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   image: DecorationImage(
//                                                     fit: BoxFit.cover,
//                                                     image: album.coverImage ==
//                                                             null
//                                                         ? const AssetImage(
//                                                             'assets/_joker1.png')
//                                                         : CachedNetworkImageProvider(
//                                                             album.coverImage!),
//                                                   )),
//                                             ),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               album.title ?? "unknown",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 18),
//                                             ),
//                                             Text(
//                                               album.artists!
//                                                   .map((artist) =>
//                                                       artist.artistName)
//                                                   .join(','),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color: Colors.grey),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Text(
//                     "Quick Picks Artist",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8.0, bottom: 10),
//                   child: SizedBox(
//                     height: 225,
//                     child: Obx(
//                       () => SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: artist_song.get_artist.map((artist) {
//                             return artist.artistName!.isEmpty
//                                 ? const SizedBox()
//                                 : GestureDetector(
//                                     onLongPress: () {
//                                       Get.bottomSheet(
//                                         elevation: 5,
//                                         DraggableScrollableSheet(builder:
//                                             (BuildContext context,
//                                                 ScrollController
//                                                     scrollController) {
//                                           return ContextBottomSheet(
//                                               controllers: scrollController,
//                                               context: ActionContext(
//                                                   entityType: EntityType.artist,
//                                                   entity: artist,
//                                                   page: PageContext.home,
//                                                   isOwner: false,
//                                                   isSaved: false));
//                                         }),
//                                         isScrollControlled: true,
//                                       );
//                                     },
//                                     onTap: () {
//                                       artist_song
//                                           .retrive_artist_with_song(artist.id);
//                                       Get.toNamed(App_route.artist_page, id: 1);
//                                     },
//                                     child: Container(
//                                       width: 160,
//                                       color: Colors.transparent,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             // left: 8.0,
//                                             ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Card(
//                                               semanticContainer: true,
//                                               borderOnForeground: true,
//                                               shape: const CircleBorder(),
//                                               clipBehavior: Clip.hardEdge,
//                                               child: artist.artistImage != null
//                                                   ? CachedNetworkImage(
//                                                       imageUrl:
//                                                           artist.artistImage ??
//                                                               '',
//                                                       placeholder:
//                                                           (context, url) =>
//                                                               Center(
//                                                         child: Container(
//                                                           color: Colors.black,
//                                                         ),
//                                                       ),
//                                                       errorWidget: (context,
//                                                               url, error) =>
//                                                           const Icon(
//                                                               Icons.error),
//                                                       width: 140,
//                                                       height: 140,
//                                                       fit: BoxFit.cover,
//                                                     )
//                                                   : Image.asset(
//                                                       'assets/_joker1.png'),
//                                             ),
//                                             const SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                               artist.artistName ?? "unknown",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 18),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Obx(
//               //   ()=> SliverList(delegate: SliverChildListDelegate(
//               //       album_song.album_song.map((song){
//               //         return Column(
//               //           children: [
//               //             CircleAvatar(
//               //               backgroundImage: NetworkImage(song.coverImage ?? ""),
//               //             ),
//               //             Text(song.songAlbum!.map((songname)=> songname.title).join(','))
//               //           ],
//               //         );
//               //       }).toList()
//               //   )),
//               // ),
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 50,
//                   child: ElevatedButton(
//                       onPressed: () {
//                         controller_song.get_all_songs();
//                         like.get_current_user_like_songs();
//                         artist_song.get_full_aritist_list();
//                         album_song.get_song_album();
//                       },
//                       child: Obx(() => Text(like.like_song
//                           .map((f) => f.song!.title)
//                           .toList()
//                           .toString()))),
//                 ),
//               ),
//               const SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 1100,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class pinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//   final double height;
//
//   pinnedHeaderDelegate({required this.child, required this.height});
//
//   @override
//   double get minExtent => height;
//
//   @override
//   double get maxExtent => height;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Material(
//       // color: Colors.white,
//       child: child,
//     );
//   }
//
//   @override
//   bool shouldRebuild(covariant pinnedHeaderDelegate oldDelegate) {
//     return false;
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/action/action_context.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';
import 'package:youtube_music/route/app_route.dart';

import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../like_page/like_controller.dart';
import '../main_home_page/main_home_page_controller.dart';
import 'controllers/all_song_controller.dart';

// ── Dark theme palette ─────────────────────────────────────────────────────────
const _kBg = Color(0xFF0C0C14);
const _kCard = Color(0xFF15151F);
const _kText = Color(0xFFF0ECE4);
const _kAccent = Color(0xFF818CF8);
const _kAccentDeep = Color(0xFF4F46E5);

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final Main_Home_Page_Controller main_home =
  Get.find<Main_Home_Page_Controller>();
  final user_details_controller controller =
  Get.find<user_details_controller>();
  final get_all_song_controller controller_song =
  Get.find<get_all_song_controller>();
  final get_current_song pick_current_song = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();
  final Album_Controller album_song = Get.find<Album_Controller>();
  final Artist_Controller artist_song = Get.find<Artist_Controller>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _kBg,
        body: RefreshIndicator(
          color: _kAccent,
          displacement: 100,
          backgroundColor: _kCard,
          onRefresh: () async {
            await main_home.refreshHome([
              controller.fetch_user(),
              controller_song.get_all_songs(),
              controller_song.get_all_Genre(),
              like.get_current_user_like_songs(),
              album_song.get_song_album(),
              artist_song.get_full_aritist_list(),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              // ── App Bar ───────────────────────────────────────────
              SliverAppBar(
                backgroundColor: _kBg,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30, height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                leadingWidth: 60,
                floating: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(App_route.history_page, id: 1);
                    },
                    icon: const Icon(Icons.history_rounded),
                    color: _kText.withOpacity(0.65),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded),
                    color: _kText.withOpacity(0.65),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(App_route.profile_page);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Obx(() {
                        final user = controller.user.value;
                        return Container(
                          width: 34, height: 34,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                            ),
                          ),
                          child: ClipOval(
                            child: user == null
                                ? Image.asset('assets/_joker1.png', fit: BoxFit.cover)
                                : Image(image: NetworkImage(user.photoUrl), fit: BoxFit.cover),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),

              // ── Genre chips ───────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: pinnedHeaderDelegate(
                  height: 50,
                  child: Container(
                    color: _kBg,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Obx(
                            () => ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller_song.genres.length,
                          itemBuilder: (BuildContext context, int index) {
                            final genreName = controller_song.genres[index];
                            final isFirst = index == 0;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: isFirst
                                      ? const LinearGradient(colors: [_kAccentDeep, Color(0xFF7C3AED)])
                                      : null,
                                  color: isFirst ? null : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isFirst
                                        ? Colors.transparent
                                        : Colors.white.withOpacity(0.10),
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${genreName.genreName}",
                                    style: TextStyle(
                                      color: isFirst ? Colors.white : _kText.withOpacity(0.55),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Section: Quick Picks ──────────────────────────────
              _sectionHeader('Quick Picks'),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: Obx(() {
                    if (controller_song.is_loading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: _kAccent),
                      );
                    }

                    if (controller_song.songs.isEmpty) {
                      return Center(
                        child: Text(
                          'No songs available',
                          style: TextStyle(color: _kText.withOpacity(0.40)),
                        ),
                      );
                    }

                    return PageView.builder(
                      itemCount: controller_song.songs.length,
                      controller: PageController(viewportFraction: 1),
                      itemBuilder: (context, index) {
                        final song = controller_song.songs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              pick_current_song.autoSongType(song, 0);
                              Get.toNamed(App_route.full_screen_media_player_page);
                            },
                            onLongPress: () {
                              Get.bottomSheet(
                                elevation: 5,
                                DraggableScrollableSheet(builder:
                                    (BuildContext context, ScrollController scrollController) {
                                  return ContextBottomSheet(
                                      controllers: scrollController,
                                      context: ActionContext(
                                          entityType: EntityType.song,
                                          entity: song,
                                          page: PageContext.home,
                                          isOwner: true,
                                          isSaved: false));
                                }),
                                isScrollControlled: true,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: _kCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.07), width: 0.5),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: song.coverImage ?? '',
                                      height: 66, width: 66,
                                      placeholder: (context, url) => Container(
                                        height: 66, width: 66,
                                        color: const Color(0xFF1E1040),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        height: 66, width: 66,
                                        color: const Color(0xFF1E1040),
                                        child: const Icon(Icons.music_note_rounded, color: _kAccent),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          song.title ?? "unknown",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: _kText),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          song.artist!.map((artist) => artist.artistName).join(','),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: _kText.withOpacity(0.40), fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.bottomSheet(
                                        elevation: 5,
                                        DraggableScrollableSheet(builder:
                                            (BuildContext context, ScrollController scrollController) {
                                          return ContextBottomSheet(
                                              controllers: scrollController,
                                              context: ActionContext(
                                                  entityType: EntityType.song,
                                                  entity: song,
                                                  page: PageContext.home,
                                                  isOwner: true,
                                                  isSaved: false));
                                        }),
                                        isScrollControlled: true,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: _kText.withOpacity(0.35),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),

              // ── Section: Quick Picks Album ────────────────────────
              _sectionHeader('Quick Picks Album'),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: SizedBox(
                    height: 225,
                    child: Obx(
                          () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: album_song.album_song.map((album) {
                            return album.songAlbum!.isEmpty
                                ? const SizedBox()
                                : GestureDetector(
                              onLongPress: () {
                                Get.bottomSheet(
                                  elevation: 5,
                                  DraggableScrollableSheet(builder:
                                      (BuildContext context, ScrollController scrollController) {
                                    return ContextBottomSheet(
                                        controllers: scrollController,
                                        context: ActionContext(
                                            entityType: EntityType.album,
                                            entity: album,
                                            page: PageContext.home,
                                            isOwner: false,
                                            isSaved: false));
                                  }),
                                  isScrollControlled: true,
                                );
                              },
                              onTap: () async {
                                await album_song.retrive_album_song_con(album.id);
                                Get.toNamed(App_route.album_page, id: 1);
                              },
                              child: Container(
                                width: 160,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF1E1040), Color(0xFF1E3A5F)],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _kAccentDeep.withOpacity(0.20),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: album.coverImage == null
                                              ? Image.asset('assets/_joker1.png', fit: BoxFit.cover)
                                              : CachedNetworkImage(
                                            imageUrl: album.coverImage!,
                                            fit: BoxFit.cover,
                                            placeholder: (c, u) => const SizedBox(),
                                            errorWidget: (c, u, e) =>
                                            const Icon(Icons.album_outlined, color: _kAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        album.title ?? "unknown",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: _kText),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        album.artists!.map((artist) => artist.artistName).join(','),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: _kText.withOpacity(0.35), fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Section: Quick Picks Artist ───────────────────────
              _sectionHeader('Quick Picks Artist'),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: SizedBox(
                    height: 210,
                    child: Obx(
                          () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: artist_song.get_artist.map((artist) {
                            return artist.artistName!.isEmpty
                                ? const SizedBox()
                                : GestureDetector(
                              onLongPress: () {
                                Get.bottomSheet(
                                  elevation: 5,
                                  DraggableScrollableSheet(builder:
                                      (BuildContext context, ScrollController scrollController) {
                                    return ContextBottomSheet(
                                        controllers: scrollController,
                                        context: ActionContext(
                                            entityType: EntityType.artist,
                                            entity: artist,
                                            page: PageContext.home,
                                            isOwner: false,
                                            isSaved: false));
                                  }),
                                  isScrollControlled: true,
                                );
                              },
                              onTap: () {
                                artist_song.retrive_artist_with_song(artist.id);
                                Get.toNamed(App_route.artist_page, id: 1);
                              },
                              child: Container(
                                width: 140,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120, height: 120,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [_kAccentDeep, Color(0xFFDB2777)],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(2.5),
                                        child: ClipOval(
                                          child: artist.artistImage != null
                                              ? CachedNetworkImage(
                                            imageUrl: artist.artistImage ?? '',
                                            placeholder: (context, url) => Container(
                                              color: const Color(0xFF1E1040),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: const Color(0xFF1E1040),
                                              child: const Icon(Icons.person, color: _kAccent),
                                            ),
                                            width: 120, height: 120,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.asset('assets/_joker1.png', fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        artist.artistName ?? "unknown",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: _kText),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable section header ─────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _kText,
                letterSpacing: -0.2,
              ),
            ),
            const Spacer(),
            const Text(
              'See all',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _kAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class pinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  pinnedHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: _kBg,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant pinnedHeaderDelegate oldDelegate) {
    return false;
  }
}