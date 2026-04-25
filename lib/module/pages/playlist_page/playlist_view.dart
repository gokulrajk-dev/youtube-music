import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';
import 'package:youtube_music/module/pages/playlist_page/playlist_controller.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../../../widgets/songListView.dart';
import '../../../route/app_route.dart';
import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../like_page/like_views.dart';

class Playlist_Views extends GetView<Playlist_Controller> {
  final get_current_song song = Get.find<get_current_song>();
  final user_details_controller user = Get.find<user_details_controller>();
   Playlist_Views({super.key});

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
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            )),
      ),
      body: Obx(() {
        final playlist_song = controller.user_playlist_song.value;
        final userdetails = user.user.value;
        final songs_only = playlist_song?.songs ?? [];
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
                        image: playlist_song!.playlistcoverimage == null
                            ? const AssetImage('assets/_joker1.png')
                            : NetworkImage(
                                playlist_song.playlistcoverimage ?? ""),
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
                    playlist_song.playlistName ?? 'unknown',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
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
                  // todo binding to add the playlist view
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child:  Text(
                      playlist_song.isPublic == false ?'Private':'Public',
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
                            song.autoSongType(songs_only, 0);
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
                              DraggableScrollableSheet(
                                expand: false,
                                builder: (context, scrollController) {
                                  return Container(
                                    color: Colors.black,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Get.back();
                                            song.autoplayNextDataType(songs_only,0);
                                          },
                                          leading: Icon(Icons.playlist_play,color: Colors.white,),
                                          title: Text('play next',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Get.back();
                                            song.AddToQueue(songs_only);
                                          },
                                          leading: Icon(Icons.playlist_play,color: Colors.white,),
                                          title: Text('Add to Queue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                        ), ListTile(
                                          onTap: () {
                                            Get.back();
                                            Get.bottomSheet(
                                              DraggableScrollableSheet(
                                                expand: false,
                                                builder: (context, scrollController) {
                                                  return showPlaylistBottomSheet(
                                                    controller: scrollController,
                                                    songId: songs_only.map((song)=>song.id).toList(),
                                                  );
                                                },
                                              ),
                                              isScrollControlled: true,
                                            );
                                          },
                                          leading: Icon(Icons.playlist_play,color: Colors.white,),
                                          title: Text('Save to playlist',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Get.back();
                                          },
                                          leading: Icon(CupertinoIcons.arrow_down_to_line_alt,color: Colors.white,),
                                          title: Text('Download',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
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
                onTap: () {},
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
            // Column(
            //     children: playlist_song.songs!.map((playlist_songs) {
            //   return ListTile(
            //       onTap: () {
            //         song.get_current_user_pick_song(playlist_songs.id);
            //       },
            //       style: ListTileStyle.drawer,
            //       leading: Image.network(playlist_songs.coverImage ?? ''),
            //       titleAlignment: ListTileTitleAlignment.center,
            //       title: Text(
            //         playlist_songs.title ?? "Unknown",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20),
            //       ),
            //       subtitle: Text(
            //         playlist_songs.artist!
            //             .map((artist) => artist.artistName)
            //             .join(','),
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 13,
            //         ),
            //         softWrap: true,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       trailing: IconButton(
            //           onPressed: () {
            //             Get.bottomSheet(
            //               elevation: 5,
            //               DraggableScrollableSheet(
            //                 expand: false,
            //                 builder: (context, scrollController) {
            //                   return globle_bottom_sheet(
            //                     controllers: scrollController,
            //                     song_cover_img: playlist_songs.coverImage,
            //                     song_title: playlist_songs.title,
            //                     song_artist: playlist_songs.artist,
            //                     song_id: playlist_songs.id,
            //                   );
            //                 },
            //               ),
            //               isScrollControlled: true,
            //             );
            //           },
            //           icon: Icon(
            //             Icons.more_vert,
            //             color: Colors.white,
            //           )));
            // }).toList()),
            SongListViews(
              songs: songs_only,
              onTap: (selectedSong){
                final index = songs_only.indexOf(selectedSong);
                song.autoSongType(songs_only, index);
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
