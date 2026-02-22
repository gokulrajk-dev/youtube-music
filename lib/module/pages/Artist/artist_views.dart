import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';

import '../../../services/helper_code/helper_code.dart';
import '../../../widgets/songListView.dart';
import '../like_page/like_views.dart';

class Artist_Views extends GetView<Artist_Controller>{
  final get_current_song song = Get.find<get_current_song>();
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
        final artist_song = controller.retrive_artist.value;
        final song_only = artist_song?.SongArtist ?? [];
        // final song_date = song_only.releaseDate;
        // DateTime dateTime = DateTime.parse(song_date!);
        // final year = dateTime.year.toString();

        if(controller.is_loading.value){
          return Center(
            child: CircularProgressIndicator(color: Colors.white,),
          );
        }
        if(controller.error.value.isNotEmpty){
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
                        image:artist_song!.artistImage == null
                            ? AssetImage('assets/_joker1.png')
                            : NetworkImage(
                            artist_song.artistImage ?? ""),
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
                    artist_song.artistName ?? 'unknown',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child:
                    Text(
                      artist_song.artistBio ?? 'unknown',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  Container(
                    // width: 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Like_Views.rowicon(
                            Icon(
                              CupertinoIcons.arrow_down_to_line,
                              color: Colors.white,
                            ),
                                () {},
                            Colors.white.withOpacity(0.2)),
                        Like_Views.rowicon(
                            Icon(
                              Icons.add_to_photos_outlined,
                              color: Colors.white,
                            ),
                                () {},
                            Colors.white.withOpacity(0.2)),
                        Like_Views.rowicon(
                            Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 50,
                            ),
                                () {},
                            Colors.white),
                        Like_Views.rowicon(
                            Icon(
                              CupertinoIcons.arrow_turn_up_right,
                              color: Colors.white,
                            ),
                                () {},
                            Colors.white.withOpacity(0.2)),
                        Like_Views.rowicon(
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
              songs: song_only,
              onTap: (selectedSong) {
                song.get_current_user_pick_song(selectedSong.id);
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