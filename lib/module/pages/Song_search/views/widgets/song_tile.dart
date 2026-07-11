import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';

import '../../../../../core/action/action_context.dart';
import '../../../../../data/data_module/song_module.dart';
import '../../../../../route/app_route.dart';
import '../../../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class SongSearchTile extends StatelessWidget {
  final Song song;
  final get_current_song current_song = Get.find<get_current_song>();

   SongSearchTile({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text("Songs",style: TextStyle(color: Colors.grey),),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () {
            current_song.autoSongType(song, 0);
            Get.toNamed(
              App_route.full_screen_media_player_page,
            );
          },
          onLongPress: () {
            Get.bottomSheet(
              DraggableScrollableSheet(
                builder: (BuildContext context, ScrollController scrollController) {
                  return ContextBottomSheet(
                      controllers: scrollController,
                      context: ActionContext(
                          entityType: EntityType.song,
                          entity: song,
                          page: PageContext.home,
                          isOwner: true,
                          isSaved: false));
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(
            song.artist?.map((artist) => artist.artistName).join(', ') ?? "",
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
                  builder:
                      (BuildContext context, ScrollController scrollController) {
                    return ContextBottomSheet(
                        controllers: scrollController,
                        context: ActionContext(
                            entityType: EntityType.song,
                            entity: song,
                            page: PageContext.home,
                            isOwner: true,
                            isSaved: false));
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
      ],
    );
  }
}
