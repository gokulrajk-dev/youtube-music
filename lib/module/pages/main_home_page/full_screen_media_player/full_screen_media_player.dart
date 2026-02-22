import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';


import '../../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../../like_page/like_controller.dart';
import '../../profile/profile_views.dart';

enum type_name { like, commant, save, share, download, mix }

class full_screen_media_player extends StatefulWidget {
  const full_screen_media_player({super.key});

  @override
  State<full_screen_media_player> createState() =>
      _full_screen_media_playerState();
}

class _full_screen_media_playerState extends State<full_screen_media_player> {
  final get_current_song song = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();

  List<Feature> get feature => [
    Feature(
      icon: like.get_song_like_or_not(song.current_song.value!.id)?CupertinoIcons.hand_thumbsup_fill:CupertinoIcons.hand_thumbsup,
      text: type_name.like,
      onTap: () async {
        await like.post_del_user_like(song.current_song.value!.id);
        await song.get_current_user_pick_song(song.current_song.value!.id);
      }
    ),
    Feature(
      icon: Icons.insert_comment_outlined,
      text: type_name.commant,
    ),
    Feature(
      icon: Icons.playlist_add,
      text: type_name.save,
    ),
    Feature(
      icon: CupertinoIcons.arrow_turn_up_right,
      text: type_name.share,
    ),
    Feature(
      icon: CupertinoIcons.arrow_down_to_line_alt,
      text: type_name.download,
    ),
    Feature(
      icon: CupertinoIcons.dot_radiowaves_left_right,
      text: type_name.mix,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
                title: Center(
                  child: Text(
                    'No Video Support',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                titleAlignment: ListTileTitleAlignment.center,
                trailing: IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        elevation: 5,
                        DraggableScrollableSheet(
                          expand: false,
                          builder: (context,
                              scrollController) {
                            return globle_bottom_sheet(
                              controllers:
                              scrollController,
                              song_artist: song.current_song.value!.artist,
                              song_title: song.current_song.value!.title,
                              song_cover_img: song.current_song.value!.coverImage,
                              song_id: song.current_song.value!.id,
                              album_id: song.current_song.value!.album!.id,
                              artist_id: song.current_song.value!.artist!.first.id,
                            );
                          },
                        ),
                        isScrollControlled: true,
                      );
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    )),
              ),
              Card(
                semanticContainer: true,
                borderOnForeground: true,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  song.current_song.value!.coverImage ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.current_song.value!.title ?? "Unknown",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Text(
                      song.current_song.value!.artist
                          !.map((artist) => artist.artistName)
                          .join(',') as String,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: SizedBox(
                  height: 65,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: feature.length,
                      itemBuilder: (context, index) {
                        final item = feature[index];
                        return Obx(() {
                          final featrue = song.current_song.value;
                          dynamic value = '';
                          switch (item.text) {
                            case type_name.like:
                              value = featrue!.likesCount.toString();
                              break;
                            case type_name.commant:
                              value = 'Command';
                              break;
                            case type_name.save:
                              value = 'Save';
                              break;
                            case type_name.share:
                              value = 'Share';
                              break;
                            case type_name.download:
                              value = 'Download';
                              break;
                            case type_name.mix:
                              value = 'Mix';
                              break;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0,left: 10,bottom: 8),
                            child: GestureDetector(
                              onTap: item.onTap,
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0,left: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(item.icon,color: Colors.white,),
                                      value==''?SizedBox():Text(
                                        value,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
