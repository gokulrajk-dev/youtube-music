import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/action/action_context.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';

import '../../../route/app_route.dart';
import '../../../services/helper_code/helper_code.dart';
import '../../../widgets/songListView.dart';
import '../Artist/artist_controller.dart';
import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../like_page/like_views.dart';

class Album_Views extends GetView<Album_Controller> {
  final get_current_song song = Get.find<get_current_song>();
  final Artist_Controller artist_song = Get.find<Artist_Controller>();

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
        final albumSong = controller.retrive_album_song.value;
        final songOnly = albumSong?.songAlbum ?? [];
        final songDate = albumSong!.releaseDate;
        DateTime dateTime = DateTime.parse(songDate!);
        final year = dateTime.year.toString();

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

        return ListView(
          children: [
            GestureDetector(
              onTap: () {
                artist_song
                    .retrive_artist_with_song(albumSong.artists!.first.id);
                Get.toNamed(App_route.artist_page, id: 1);
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          albumSong.artists!.first.artistImage == null
                              ? const AssetImage('assets/img.png')
                              : NetworkImage(
                                  albumSong.artists!.first.artistImage ?? "",
                                  scale: 1,
                                ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      albumSong.artists!.first.artistName ?? 'unknown',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                  child: Text(
                'Album.$year',
                style: const TextStyle(color: Colors.grey),
              )),
            ),
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: albumSong.coverImage == null
                            ? const AssetImage('assets/_joker1.png')
                            : CachedNetworkImageProvider(
                                albumSong.coverImage ?? ""),
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
                    albumSong.title ?? 'unknown',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      albumSong.description ?? 'unknown',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  Container(
                    // width: 230,
                    child: Row(
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
                              Icons.add_to_photos_outlined,
                              color: Colors.white,
                            ),
                            () {},
                            Colors.white.withOpacity(0.2)),
                        Like_Views.rowicon(
                            const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 50,
                            ), () {
                          song.autoSongType(songOnly, 0);
                          Get.toNamed(App_route.full_screen_media_player_page);
                        }, Colors.white),
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
                            ), () {
                          Get.bottomSheet(
                            elevation: 5,
                            DraggableScrollableSheet(builder:
                                (BuildContext context,
                                    ScrollController scrollController) {
                              return ContextBottomSheet(
                                  controllers: scrollController,
                                  context: ActionContext(
                                      entityType: EntityType.album,
                                      entity: albumSong,
                                      page: PageContext.album,
                                      isOwner: false,
                                      isSaved: false));
                            }),
                            isScrollControlled: true,
                          );
                        }, Colors.white.withOpacity(0.2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SongListViews(
              songs: songOnly,
              typeOfcontext: PageContext.album,
              onTap: (selectedSong) {
                final index = songOnly.indexOf(selectedSong);
                song.autoSongType(songOnly, index);
                Get.toNamed(App_route.full_screen_media_player_page);
              },
            ),
            Container(
              height: 100,
            )
          ],
        );
      }),
    );
  }
}
