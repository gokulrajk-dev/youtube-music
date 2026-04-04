import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/history/history_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';

class History_Views extends GetView<Histroy_Controller> {
  final get_current_song pick_current_song = Get.find<get_current_song>();

  History_Views({super.key});

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
        if (controller.is_loading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.history.length,
              itemBuilder: (context, index) {
                final history_song = controller.history[index];
                final song = history_song.song!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0 || history_song.days != controller.history[index - 1].days)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            history_song.days ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      ListTile(
                        onTap: () {
                          pick_current_song.get_current_user_pick_song(song.id);
                        },
                        onLongPress: () {
                          Get.bottomSheet(
                            elevation: 5,
                            DraggableScrollableSheet(
                              expand: false,
                              builder: (context, scrollController) {
                                return globle_bottom_sheet(
                                  controllers: scrollController,
                                  song: song,
                                );
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        subtitle: Text(
                          song.artist
                                  ?.map((artist) => artist.artistName)
                                  .join(', ') ??
                              "",
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
                                expand: false,
                                builder: (context, scrollController) {
                                  return globle_bottom_sheet(
                                    controllers: scrollController,
                                    song: song,
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
                  ),
                );
              },
            ),
            const SizedBox(
              height: 100,
            )
          ],
        );
      }),
    );
  }
}
