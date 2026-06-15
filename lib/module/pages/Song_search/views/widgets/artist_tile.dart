import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Artist/artist_controller.dart';

import '../../../../../core/action/action_context.dart';
import '../../../../../data/data_module/artist.dart';
import '../../../../../route/app_route.dart';
import '../../../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class ArtistSearchTile extends StatelessWidget {
  final Artist artist;
  final Artist_Controller artist_controller = Get.find<Artist_Controller>();

    ArtistSearchTile({
    super.key,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        onTap: () {
          artist_controller
              .retrive_artist_with_song(artist.id);
          Get.toNamed(
            App_route.artist_page,id:2
          );
        },
        onLongPress: () {
          Get.bottomSheet(
            DraggableScrollableSheet(
              builder: (BuildContext context, ScrollController scrollController) {
                return ContextBottomSheet(
                    controllers: scrollController,
                    context: ActionContext(
                        entityType: EntityType.artist,
                        entity: artist,
                        page: PageContext.home,
                        isOwner: true,
                        isSaved: false
                    )
                );
              },
            ),
            isScrollControlled: true,
          );
        },
        style: ListTileStyle.drawer,
        leading: artist.artistImage != null
            ? Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle
          ),
            child: Image.network(artist.artistImage!))
            : const Icon(Icons.music_note, color: Colors.white),
        title: Text(
          artist.artistName ?? "Unknown",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // subtitle: Text(
        //   artist.artist?.map((artist) => artist.artistName).join(', ') ?? "",
        //   style: const TextStyle(
        //     color: Colors.grey,
        //     fontSize: 13,
        //   ),
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
        trailing: IconButton(
          onPressed: () {
            Get.bottomSheet(
              DraggableScrollableSheet(
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return ContextBottomSheet(
                      controllers: scrollController,
                      context: ActionContext(
                          entityType: EntityType.artist,
                          entity: artist,
                          page: PageContext.home,
                          isOwner: true,
                          isSaved: false
                      )
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
  }
}
