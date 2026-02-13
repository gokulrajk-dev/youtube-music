import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/library/like_page/like_controller.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class Like_Views extends GetView<Like_Controller> {
  final get_current_song con = Get.find<get_current_song>();
  final helper_code help = helper_code();

  @override
  Widget build(BuildContext context) {
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
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text('${controller.error.value}'),
          );
        }

        return ListView.builder(
            itemCount: controller.like_song.length,
            itemBuilder: (context, index) {
              final like = controller.like_song[index];
              return ListTile(
                  onTap: () {
                    con.get_current_user_pick_song(like.song.id);
                  },
                  style: ListTileStyle.drawer,
                  leading: Image.network(like.song.coverImage),
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text(
                    like.song.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    like.song.artist
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
                                song_cover_img: like.song.coverImage,
                                song_title: like.song.title,
                                song_artist: like.song.artist,
                                song_id: like.song.id,
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
            });
      }),
    );
  }
}
