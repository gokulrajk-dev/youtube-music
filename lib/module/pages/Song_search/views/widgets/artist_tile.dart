import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/action/action_context.dart';
import '../../../../../data/data_module/artist.dart';
import '../../../../../route/app_route.dart';
import '../../../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class ArtistSearchTile extends StatelessWidget {
  final Artist artist;

   const ArtistSearchTile({
    super.key,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
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
    );
  }
}
