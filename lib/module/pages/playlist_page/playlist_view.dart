import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/action/action_context.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';
import 'package:youtube_music/module/pages/playlist_page/playlist_controller.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../../../widgets/songListView.dart';
import '../../../route/app_route.dart';
import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../like_page/like_views.dart';
import '../main_home_page/main_home_page_controller.dart';

class Playlist_Views extends GetView<Playlist_Controller> {
  final get_current_song song = Get.find<get_current_song>();
  final user_details_controller user = Get.find<user_details_controller>();
   Playlist_Views({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              helper_code.helper();
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            )),
      ),
      body: Obx(() {
        final playlistSong = controller.user_playlist_song.value;
        final userdetails = user.user.value;
        final songsOnly = playlistSong?.songs ?? [];
        if (controller.is_loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(controller.error.value),
          );
        }
        return ListView(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: playlistSong!.playlistcoverimage == null
                            ? const AssetImage('assets/_joker1.png')
                            : NetworkImage(
                                playlistSong.playlistcoverimage ?? ""),
                        scale: 1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playlistSong.playlistName ?? 'unknown',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(App_route.profile_page,);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: userdetails!.photoUrl == null
                              ? const AssetImage('assets/img.png')
                              : NetworkImage(
                                  userdetails.photoUrl,
                                  scale: 1,
                                ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userdetails.userName,
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  // todo binding to add the playlist view
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child:  Text(
                      playlistSong.isPublic == false ?'Private':'Public',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Like_Views.rowicon(
                          const Icon(
                            CupertinoIcons.arrow_down_to_line,
                            color: Colors.white,
                          ),
                          () {},
                          Colors.white.withOpacity(0.2)),
                      Like_Views.rowicon(
                          const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                          () {},
                          Colors.white.withOpacity(0.2)),
                      Like_Views.rowicon(
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 50,
                          ),
                          () {
                            song.autoSongType(songsOnly, 0);
                            Get.toNamed(App_route.full_screen_media_player_page);
                          },
                          Colors.white),
                      Like_Views.rowicon(
                          const Icon(
                            CupertinoIcons.arrow_turn_up_right,
                            color: Colors.white,
                          ),
                          () {},
                          Colors.white.withOpacity(0.2)),
                      Like_Views.rowicon(
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          () {
                            Get.bottomSheet(
                              elevation: 5,
                              DraggableScrollableSheet(builder:
                                  (BuildContext context,
                                  ScrollController scrollController) {
                                return ContextBottomSheet(
                                    controllers: scrollController,
                                    context: ActionContext(
                                        entityType: EntityType.playlist,
                                        entity: playlistSong,
                                        page: PageContext.playlist,
                                        isOwner: false,
                                        isSaved: false));
                              }),
                              isScrollControlled: true,
                            );
                          },
                          Colors.white.withOpacity(0.2)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 18.0),
              child: ListTile(
                // todo add the song in the playlist
                onTap: () {
                  final mainPage = Get.find<Main_Home_Page_Controller>();
                  final naviId = NavHelper.getNavId(mainPage.current_index.value);
                  Get.toNamed(App_route.search_page,id: naviId);
                },
                leading: Container(
                  width: 65,
                  height: 100,
                  color: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Add a Song',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SongListViews(
              songs: songsOnly,
              typeOfcontext: PageContext.playlist,
              onTap: (selectedSong){
                final index = songsOnly.indexOf(selectedSong);
                song.autoSongType(songsOnly, index);
                Get.toNamed(App_route.full_screen_media_player_page);
              },
            ),
            Container(
              height: 100,
            ),
          ],
        );
      }),
    );
  }
}
