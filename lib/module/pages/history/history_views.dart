import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/history/history_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';
import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class History_Views extends GetView<Histroy_Controller> {
  final get_current_song pick_current_song = Get.find<get_current_song>();

  @override
  Widget build(BuildContext context) {
    final helper_code help = helper_code();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              help.helper();
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.white,
            )),
      ),
      body: Obx(() {
        if (controller.is_loading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.history.length,
          itemBuilder: (context, index) {
            final history_song = controller.history[index];
            final song = history_song.song!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: (){
                  pick_current_song
                      .get_current_user_pick_song(history_song.song!.id);
                },
                onLongPress: () {
                  Get.bottomSheet(
                    elevation: 5,
                    DraggableScrollableSheet(
                      expand: false,
                      builder: (context, scrollController) {
                        return globle_bottom_sheet(
                          controllers: scrollController,
                          song_artist: song.artist,
                          song_title: song.title,
                          song_cover_img: song.coverImage,
                          song_id: song.id,
                          album_id: song.album!.id,
                          artist_id: song.artist!.first.id,
                        );
                      },
                    ),
                    isScrollControlled: true,
                  );
                },
                style: ListTileStyle.drawer,
                leading: song.coverImage != null
                    ? Image.network(song.coverImage!)
                    : const Icon(Icons.music_note, color: Colors.white),

                title: Text(
                  song.title ?? "Unknown",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),

                subtitle: Text(
                  song.artist
                      ?.map((artist) => artist.artistName)
                      .join(', ') ??
                      "",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                trailing: IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      DraggableScrollableSheet(
                        expand: false,
                        builder: (context, scrollController) {
                          return globle_bottom_sheet(
                            controllers: scrollController,
                            song_cover_img: song.coverImage,
                            song_title: song.title,
                            song_artist: song.artist,
                            song_id: song.id,
                            album_id: song.album!.id,
                            artist_id: song.artist!.first.id,
                          );
                        },
                      ),
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
