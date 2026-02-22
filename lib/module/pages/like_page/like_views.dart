import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';

import 'package:youtube_music/services/helper_code/helper_code.dart';


import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import 'like_controller.dart';

class Like_Views extends GetView<Like_Controller> {
  final get_current_song con = Get.find<get_current_song>();
  final user_details_controller user = Get.find<user_details_controller>();
  final helper_code help = helper_code();

  static Widget rowicon(Icon icon, VoidCallback onTop, Color color) {
    return Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: color,
        ),
        child: Center(
          child: IconButton(
            onPressed: onTop,
            icon: icon,
          ),
        ));
  }

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            color: Colors.white,
          )
        ],
      ),
      body: ListView(
        // physics: NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage('assets/liked_pic.png'), scale: 1)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Liked Music',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  final userdetails = user.user.value;
                  if (user.is_loading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: userdetails!.photoUrl == null
                            ? AssetImage('assets/img.png')
                            : NetworkImage(userdetails.photoUrl, scale: 5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        userdetails.userName,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  );
                }),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                  child: Text(
                    'Music that you like in any Youtube app will be shown.\n                here you can change this in Settings.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                Container(
                  width: 230,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      rowicon(
                          Icon(
                            CupertinoIcons.arrow_down_to_line,
                            color: Colors.white,
                          ),
                          () {},
                          Colors.white.withOpacity(0.2)),
                      rowicon(
                          Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 50,
                          ),
                          () {},
                          Colors.white),
                      rowicon(
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          () {},
                          Colors.white.withOpacity(0.2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
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
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.like_song.length,
                itemBuilder: (context, index) {
                  final like = controller.like_song[index];
                  return ListTile(
                      onTap: () {
                        con.get_current_user_pick_song(like.song!.id);
                      },
                      style: ListTileStyle.drawer,
                      leading: Image.network(like.song!.coverImage ?? ""),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        like.song!.title ?? "Unknown",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        like.song!.artist!
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
                                    song_cover_img: like.song!.coverImage,
                                    song_title: like.song!.title,
                                    song_artist: like.song!.artist,
                                    song_id: like.song!.id,
                                    album_id: like.song!.album!.id,
                                    artist_id: like.song!.artist!.first.id,
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
          Container(
            height: 100,
          )
        ],
      ),
    );
  }
}
