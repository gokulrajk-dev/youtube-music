import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/playlist_page/playlist_controller.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../../data/data_module/song_module.dart';
import '../like_page/like_controller.dart';
import '../main_home_page/main_home_page_controller.dart';
import '../playlist_page/new_playlist_create_ui.dart';
import '../profile/profile_views.dart';

class globle_bottom_sheet extends StatefulWidget {
  final controllers;
  final Song song;
  final int? songIndex;
  final String type;

  const globle_bottom_sheet(
      {super.key,
      required this.controllers,
      required this.song,
      required this.type,
      this.songIndex});

  @override
  State<globle_bottom_sheet> createState() => _globle_bottom_sheetState();
}

class _globle_bottom_sheetState extends State<globle_bottom_sheet> {
  final get_current_song controller = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();
  final Album_Controller album = Get.find<Album_Controller>();
  final Artist_Controller artist = Get.find<Artist_Controller>();
  final main_page = Get.find<Main_Home_Page_Controller>();
  final playlist = Get.find<Playlist_Controller>();

  List<Feature> get featrue => [
        Feature(
            icon: Icons.playlist_play,
            text: 'Play Next',
            onTap: () {
              widget.type != "queue"
                  ? controller.autoplayNextDataType(widget.song, -1)
                  : controller.autoplayNextDataType(widget.song, widget.songIndex ?? -1);
              Get.back();
            }),
        Feature(
            icon: Icons.playlist_add,
            text: 'Save to playlist',
            onTap: () async {
              Get.back();
              Get.bottomSheet(
                DraggableScrollableSheet(
                  expand: false,
                  builder: (context, scrollController) {
                    return showPlaylistBottomSheet(
                      controller: scrollController,
                      songId: [widget.song.id],
                    );
                  },
                ),
                isScrollControlled: true,
              );
            }),
        Feature(icon: CupertinoIcons.share, text: 'Share'),
      ];

  List<Feature> get featrue_all => [
        Feature(
            icon: CupertinoIcons.dot_radiowaves_left_right, text: 'Start mix'),
        Feature(
            icon: Icons.queue_music,
            text: 'Add to Queue',
            onTap: () {
              controller.AddToQueue(widget.song);
              Get.back();
            }),
        Feature(icon: Icons.playlist_add, text: 'Add to Library'),
        Feature(icon: CupertinoIcons.arrow_down_to_line_alt, text: 'Download'),
        if (widget.type == "queue")
          Feature(
              icon: Icons.remove_road,
              text: 'Dismiss queue',
              onTap: () {
                controller.dismissQueue(widget.songIndex ?? -1);
                Get.back();
              }),
        if (widget.type == "playlist")
          Feature(
              icon: Icons.delete,
              text: 'Remove from playlist',
              onTap: () async {
                Get.back();
                await playlist.removeSongFromPlaylist(
                    playlist.user_playlist_song.value!.id,
                    [widget.song.id],
                    "delete",
                    widget.songIndex ?? -1);
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
                      borderRadius: BorderRadius.circular(10)
                    ),
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

class showPlaylistBottomSheet extends StatefulWidget {
  final dynamic controller;
  final List<int> songId;

  showPlaylistBottomSheet(
      {super.key, required this.controller, required this.songId});

  @override
  State<showPlaylistBottomSheet> createState() =>
      _showPlaylistBottomSheetState();
}

class _showPlaylistBottomSheetState extends State<showPlaylistBottomSheet> {
  final Playlist_Controller playlist_song = Get.find<Playlist_Controller>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        shrinkWrap: true,
        controller: widget.controller,
        children: [
          ListTile(
            title:  Text(
              'Save ${widget.songId.length} song to playlist',
              style:const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            trailing: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          ),
          const Divider(
            color: Colors.white12,
          ),
          GestureDetector(
            onTap: () {},
            child: ListTile(
              style: ListTileStyle.drawer,
              leading: Image.asset('assets/liked_pic.png'),
              title: const Text(
                'Liked Music',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              subtitle: const Text(
                '📌',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       playlist_song.show_user_playlist();
          //     },
          //     child: Text('playlist')),
          Obx(() {
            if (playlist_song.is_loading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (playlist_song.error.value.isNotEmpty) {
              return Center(
                child: Text(playlist_song.error.value),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlist_song.user_playlist.length,
              itemBuilder: (context, index) {
                final playlist = playlist_song.user_playlist[index];
                return ListTile(
                  onTap: () async {
                    Get.back();
                    await playlist_song.autoAddedSongToPlaylist(
                        playlist.id, widget.songId, "post");
                  },
                  leading: playlist.playlistcoverimage == ''
                      ? Image.network(playlist.playlistcoverimage ?? "")
                      : Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 0.5)),
                          width: 55,
                          height: 55,
                          child: const Icon(
                            Icons.music_note_outlined,
                            color: Colors.white,
                          )),
                  title: Text(
                    playlist.playlistName ?? 'unknown',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    '${playlist.songs!.length} Tracks',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      )),
                );
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            child: newPlaylistCreate(
                          songId: widget.songId,
                        ));
                      },
                    );
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white)),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '+ New playlist',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          )
        ],
      ),
    ));
  }
}
