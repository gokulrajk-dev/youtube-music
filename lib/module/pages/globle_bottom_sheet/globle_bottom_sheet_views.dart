import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/route/app_route.dart';


import '../like_page/like_controller.dart';
import '../profile/profile_views.dart';

class globle_bottom_sheet extends StatefulWidget {
  final controllers;
  final dynamic song_cover_img;
  final dynamic song_title;
  final dynamic song_artist;
  final dynamic song_id;
  final dynamic album_id;
  final dynamic artist_id;

  globle_bottom_sheet({
    super.key,
    required this.controllers,
    required this.song_cover_img,
    required this.song_title,
    required this.song_artist,
    required this.song_id,
    required this.album_id,
    required this.artist_id,
  });

  @override
  State<globle_bottom_sheet> createState() => _globle_bottom_sheetState();
}

class _globle_bottom_sheetState extends State<globle_bottom_sheet> {
  final get_current_song controller = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();
  final Album_Controller album = Get.find<Album_Controller>();
  final Artist_Controller artist = Get.find<Artist_Controller>();

  List<Feature>  featrue = [
    Feature(icon: Icons.playlist_play, text: 'Play Next'),
    Feature(icon: Icons.playlist_add, text: 'Save to playlist'),
    Feature(icon: CupertinoIcons.share, text: 'Share'),
  ];
  List<Feature> get featrue_all => [
    Feature(icon: CupertinoIcons.dot_radiowaves_left_right, text: 'Start mix'),
    Feature(icon: Icons.queue_music, text: 'Add to Queue'),
    Feature(icon: Icons.playlist_add, text: 'Add to Library'),
    Feature(icon: CupertinoIcons.arrow_down_to_line_alt, text: 'Download'),
    Feature(icon: CupertinoIcons.delete, text: 'Remove from playlist'),
    Feature(icon: Icons.album_outlined, text: 'Go to Album',onTap: () async{
      await album.retrive_album_song_con(widget.album_id);
      Get.back();
      Get.toNamed(App_route.album_page);

    }),
    Feature(icon: Icons.person_outline, text: 'Go to Artist',onTap: () async{
      await artist.retrive_artist_with_song(widget.artist_id);
      Get.back();
      Get.toNamed(App_route.artist_page);

    }),
    Feature(icon: CupertinoIcons.person_3, text: 'View song credits'),
    Feature(icon: CupertinoIcons.pin_fill, text: 'Pin to Speed dial'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.85),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              controller: widget.controllers,
              children: [
                ListTile(
                  focusColor: Colors.black,
                  leading: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.white)),
                    child: Image.network(
                      widget.song_cover_img ?? '',
                    ),
                  ),
                  title: Text(
                    widget.song_title ?? '',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  subtitle: Text(
                    widget.song_artist
                            .map((artist) => artist.artistName)
                            .join(',') ??
                        '',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Builder(builder: (context) {
                    return Obx(
                      () => IconButton(
                          onPressed: () async {
                            await like.post_del_user_like(widget.song_id);
                           await controller.get_current_user_pick_song(widget.song_id);
                          },
                          icon: Icon(
                            like.get_song_like_or_not(widget.song_id)
                                ? CupertinoIcons.hand_thumbsup_fill
                                : CupertinoIcons.hand_thumbsup,
                            color: Colors.white,
                          )),
                    );
                  }),
                ),
                Divider(),
                SizedBox(
                  height: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: featrue.map((most) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              // todo the playnext,save,share
                              child: Container(
                                height: 80,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Icon(
                                    most.icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              most.text,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  children: featrue_all.map((all) {
                    return GestureDetector(
                      onTap: all.onTap,
                      child: ListTile(
                        leading: Icon(
                          all.icon,
                          color: Colors.white,
                        ),
                        title: Text(
                          all.text,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            )),
      ),
    );
  }
}
