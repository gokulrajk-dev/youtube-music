import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';

import '../../../../../core/action/action_context.dart';
import '../../../../../data/data_module/album_module.dart';
import '../../../../../route/app_route.dart';
import '../../../../../services/helper_code/helper_code.dart';
import '../../../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../../../main_home_page/main_home_page_controller.dart';

class AlbumSearchTile extends StatelessWidget {
  final Album album;
  final Album_Controller album_controller = Get.find();

  AlbumSearchTile({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text("Albums",style: TextStyle(color: Colors.grey),),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () async {
            final mainPage = Get.find<Main_Home_Page_Controller>();
            final naviId = NavHelper.getNavId(mainPage.current_index.value);
            await album_controller.retrive_album_song_con(album.id);
            Get.toNamed(App_route.album_page, id: naviId);
          },
          onLongPress: () {
            Get.bottomSheet(
              DraggableScrollableSheet(
                builder: (BuildContext context, ScrollController scrollController) {
                  return ContextBottomSheet(
                      controllers: scrollController,
                      context: ActionContext(
                          entityType: EntityType.album,
                          entity: album,
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
          leading: album.coverImage != null
              ? Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle
              ),
              child: Image.network(album.coverImage!,fit: BoxFit.cover,))
              : const Icon(Icons.music_note, color: Colors.white),
          title: Text(
            album.title ?? "Unknown",
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
                            entityType: EntityType.album,
                            entity: album,
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
      ],
    );
  }
}
