import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../../data/data_module/song_module.dart';
import '../like_page/like_controller.dart';
import '../main_home_page/main_home_page_controller.dart';
import '../profile/profile_views.dart';

class globle_bottom_sheet extends StatefulWidget {
  final controllers;
  final Song song;
  final int? songIndex;

  const globle_bottom_sheet(
      {super.key, required this.controllers, required this.song,this.songIndex});

  @override
  State<globle_bottom_sheet> createState() => _globle_bottom_sheetState();
}

class _globle_bottom_sheetState extends State<globle_bottom_sheet> {
  final get_current_song controller = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();
  final Album_Controller album = Get.find<Album_Controller>();
  final Artist_Controller artist = Get.find<Artist_Controller>();
  final main_page = Get.find<Main_Home_Page_Controller>();

  List<Feature> get featrue => [
        if (controller.queue.isNotEmpty)
          Feature(
              icon: Icons.playlist_play,
              text: 'Play Next',
              onTap: () async {
                await controller.playNext(widget.song);
                Get.back();
              }),
        Feature(icon: Icons.playlist_add, text: 'Save to playlist'),
        Feature(icon: CupertinoIcons.share, text: 'Share'),
      ];

  List<Feature> get featrue_all => [
        Feature(
            icon: CupertinoIcons.dot_radiowaves_left_right, text: 'Start mix'),
        Feature(icon: Icons.queue_music, text: 'Add to Queue',onTap: (){
          controller.AddToQueue(widget.song);
          Get.back();
        }),
        Feature(icon: Icons.playlist_add, text: 'Add to Library'),
        Feature(icon: CupertinoIcons.arrow_down_to_line_alt, text: 'Download'),
        if(widget.songIndex !=-1)Feature(
            icon: CupertinoIcons.delete,
            text: 'Remove from queue',
            onTap: () {
              controller.dismissQueue(widget.songIndex ?? -1);
              Get.back();
            }),
        Feature(
            icon: Icons.album_outlined,
            text: 'Go to Album',
            onTap: () async {
              Get.back();
              final naviId = NavHelper.getNavId(main_page.current_index.value);
              await album.retrive_album_song_con(widget.song.album!.id);
              Get.toNamed(App_route.album_page, id: naviId);
            }),
        Feature(
            icon: Icons.person_outline,
            text: 'Go to Artist',
            onTap: () async {
              Get.back();
              final naviId = NavHelper.getNavId(main_page.current_index.value);
              await artist
                  .retrive_artist_with_song(widget.song.artist!.first.id);
              Get.toNamed(App_route.artist_page, id: naviId);
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
                      widget.song.coverImage ?? '',
                    ),
                  ),
                  title: Text(
                    widget.song.title ?? '',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  subtitle: Text(
                    widget.song.artist!
                        .map((artist) => artist.artistName)
                        .join(','),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Builder(builder: (context) {
                    return Obx(
                      () => IconButton(
                          onPressed: () async {
                            await like.post_del_user_like(widget.song.id);
                            // todo after complete sync the like inside the full screen play without call the song.
                            // await controller
                            //     .get_current_user_pick_song(widget.song_id);
                          },
                          icon: Icon(
                            like.get_song_like_or_not(widget.song.id)
                                ? CupertinoIcons.hand_thumbsup_fill
                                : CupertinoIcons.hand_thumbsup,
                            color: Colors.white,
                          )),
                    );
                  }),
                ),
                const Divider(),
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
                              onTap: most.onTap,
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
                            const Spacer(),
                            Text(
                              most.text,
                              style: const TextStyle(color: Colors.white),
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
                          style: const TextStyle(
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
