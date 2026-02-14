import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/library/playlist_page/playlist_controller.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class Playlist_Views extends GetView<Playlist_Controller> {

  final get_current_song song = Get.find<get_current_song>();

  @override
  Widget build(BuildContext context) {
    final helper_code help = helper_code();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: () {
          help.helper();
        }, icon: Icon(CupertinoIcons.back,color: Colors.white,)),
      ),
      body: Obx(
              () {
            if (controller.is_loading.value) {
              return Center(child: CircularProgressIndicator(),);
            }
            if (controller.error.value.isNotEmpty) {
              return Center(child: Text(controller.error.value),);
            }
            return ListView(
                children: controller.user_playlist_song.value!.songs!
                    .map((playlist_songs) {
                  return ListTile(
                      onTap: () {
                        song.get_current_user_pick_song(playlist_songs.id);
                      },
                      style: ListTileStyle.drawer,
                      leading: Image.network(playlist_songs.coverImage ?? ''),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        playlist_songs.title ?? "Unknown",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        playlist_songs.artist!
                            .map((artist) => artist.artistName)
                            .join(','),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              elevation: 5,
                              DraggableScrollableSheet(
                                expand: false,
                                builder: (context, scrollController) {
                                  return globle_bottom_sheet(
                                    controllers: scrollController,
                                    song_cover_img: playlist_songs.coverImage,
                                    song_title: playlist_songs.title,
                                    song_artist: playlist_songs.artist,
                                    song_id: playlist_songs.id,
                                  );
                                },
                              ),
                              isScrollControlled: true,
                            );
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )));
                }).toList());
          }),
    );
  }
}