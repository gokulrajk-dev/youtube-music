// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:youtube_music/core/action/action_context.dart';
// import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
// import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
//
// import '../../../route/app_route.dart';
// import '../../../services/helper_code/helper_code.dart';
// import '../../../widgets/songListView.dart';
// import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
// import '../like_page/like_views.dart';
//
// class Artist_Views extends GetView<Artist_Controller> {
//   final get_current_song song = Get.find<get_current_song>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//             onPressed: () {
//               helper_code.helper();
//             },
//             icon: const Icon(
//               CupertinoIcons.back,
//               color: Colors.white,
//             )),
//       ),
//       body: Obx(() {
//         final artist_song = controller.retrive_artist.value;
//         final song_only = artist_song?.SongArtist ?? [];
//         if (controller.is_loading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           );
//         }
//         if (controller.error.value.isNotEmpty) {
//           return Center(
//             child: Text(controller.error.value),
//           );
//         }
//         return ListView(
//           children: [
//             Center(
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: artist_song!.artistImage == null
//                             ? const AssetImage('assets/_joker1.png')
//                             : CachedNetworkImageProvider(artist_song.artistImage ?? ""),
//                         scale: 1)),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     artist_song.artistName ?? 'unknown',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 7,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: Text(
//                       artist_song.artistBio ?? 'unknown',
//                       style: const TextStyle(color: Colors.grey, fontSize: 13),
//                     ),
//                   ),
//                   Container(
//                     // width: 230,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Like_Views.rowicon(
//                             const Icon(
//                               CupertinoIcons.arrow_down_to_line,
//                               color: Colors.white,
//                             ),
//                             () {},
//                             Colors.white.withOpacity(0.2)),
//                         Like_Views.rowicon(
//                             const Icon(
//                               Icons.add_to_photos_outlined,
//                               color: Colors.white,
//                             ),
//                             () {},
//                             Colors.white.withOpacity(0.2)),
//                         Like_Views.rowicon(
//                             const Icon(
//                               Icons.play_arrow,
//                               color: Colors.black,
//                               size: 50,
//                             ),
//                             () {},
//                             Colors.white),
//                         Like_Views.rowicon(
//                             const Icon(
//                               CupertinoIcons.arrow_turn_up_right,
//                               color: Colors.white,
//                             ),
//                             () {},
//                             Colors.white.withOpacity(0.2)),
//                         Like_Views.rowicon(
//                             const Icon(
//                               Icons.more_vert,
//                               color: Colors.white,
//                             ), () {
//                           Get.bottomSheet(
//                             elevation: 5,
//                             DraggableScrollableSheet(builder:
//                                 (BuildContext context,
//                                     ScrollController scrollController) {
//                               return ContextBottomSheet(
//                                   controllers: scrollController,
//                                   context: ActionContext(
//                                       entityType: EntityType.artist,
//                                       entity: artist_song,
//                                       page: PageContext.artist,
//                                       isOwner: false,
//                                       isSaved: false));
//                             }),
//                             isScrollControlled: true,
//                           );
//                         }, Colors.white.withOpacity(0.2)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SongListViews(
//               songs: song_only,
//               typeOfcontext: PageContext.artist,
//               onTap: (selectedSong) {
//                 final index = song_only.indexOf(selectedSong);
//                 song.setQueue(song_only, index);
//                 Get.toNamed(App_route.full_screen_media_player_page);
//               },
//             ),
//             Container(
//               height: 100,
//             )
//           ],
//         );
//       }),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/action/action_context.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';

import '../../../route/app_route.dart';
import '../../../services/helper_code/helper_code.dart';
import '../../../widgets/songListView.dart';
import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../like_page/like_views.dart';

class Artist_Views extends GetView<Artist_Controller> {
  final get_current_song song = Get.find<get_current_song>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   leading: IconButton(
      //       onPressed: () {
      //         helper_code.helper();
      //       },
      //       icon: const Icon(
      //         CupertinoIcons.back,
      //         color: Colors.white,
      //       )),
      // ),
      body: Obx(() {
        final artist_song = controller.retrive_artist.value;
        final song_only = artist_song?.SongArtist ?? [];
        if (controller.is_loading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(controller.error.value),
          );
        }
       return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 350,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  helper_code.helper();
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  artist_song!.artistName ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    artist_song.artistImage == null
                        ? Image.asset(
                      "assets/_joker1.png",
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      imageUrl: artist_song.artistImage!,
                      fit: BoxFit.cover,
                    ),

                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      artist_song.artistBio ?? "Unknown",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Like_Views.rowicon(
                          const Icon(
                            CupertinoIcons.arrow_down_to_line,
                            color: Colors.white,
                          ),
                              () {},
                          Colors.white.withOpacity(.2),
                        ),
                        Like_Views.rowicon(
                          const Icon(
                            Icons.add_to_photos_outlined,
                            color: Colors.white,
                          ),
                              () {},
                          Colors.white.withOpacity(.2),
                        ),
                        Like_Views.rowicon(
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 50,
                          ),
                              () {},
                          Colors.white,
                        ),
                        Like_Views.rowicon(
                          const Icon(
                            CupertinoIcons.arrow_turn_up_right,
                            color: Colors.white,
                          ),
                              () {},
                          Colors.white.withOpacity(.2),
                        ),
                        Like_Views.rowicon(
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                              () {
                            Get.bottomSheet(
                              elevation: 5,
                              isScrollControlled: true,
                              DraggableScrollableSheet(
                                builder: (context, scrollController) {
                                  return ContextBottomSheet(
                                    controllers: scrollController,
                                    context: ActionContext(
                                      entityType: EntityType.artist,
                                      entity: artist_song,
                                      page: PageContext.artist,
                                      isOwner: false,
                                      isSaved: false,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          Colors.white.withOpacity(.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SongListViews(
                songs: song_only,
                typeOfcontext: PageContext.artist,
                onTap: (selectedSong) {
                  final index = song_only.indexOf(selectedSong);
                  song.setQueue(song_only, index);
                  Get.toNamed(App_route.full_screen_media_player_page);
                },
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 200),
            ),
          ],
        );
      }),
    );
  }
}
