import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_player_controller.dart';

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

class _full_screen_media_playerState extends State<full_screen_media_player>
    with SingleTickerProviderStateMixin {
  final get_current_song song = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();
  final full_screen_media_player_controller music_player =
      Get.find<full_screen_media_player_controller>();
  late PageController pageController;

  @override
  void initState() {
    pageController = music_player.pageController;
    super.initState();
  }

  @override
  void dispose() {
    song.isshuffleenabled.value = false;
    super.dispose();
  }

  Widget text(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  List<Feature> get feature => [
        Feature(
            icon: like.get_song_like_or_not(song.current_song.value!.id)
                ? CupertinoIcons.hand_thumbsup_fill
                : CupertinoIcons.hand_thumbsup,
            text: type_name.like,
            onTap: () async {
              await like.post_del_user_like(song.current_song.value!.id);
              await song
                  .get_current_user_pick_song(song.current_song.value!.id);
            }),
        Feature(
          icon: Icons.insert_comment_outlined,
          text: type_name.commant,
        ),
        Feature(
            icon: Icons.playlist_add,
            text: type_name.save,
            onTap: () {
              Get.bottomSheet(
                DraggableScrollableSheet(
                  expand: false,
                  builder: (context, scrollController) {
                    return showPlaylistBottomSheet(
                      controller: scrollController,
                      songId: [song.current_song.value!.id],
                    );
                  },
                ),
                isScrollControlled: true,
              );
            }),
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
          () {
            if (song.current_song.value == null) {
              return Center(
                child: SizedBox.fromSize(),
              );
            }
            if (song.error.value.isNotEmpty) {
              return Center(
                child: Text(song.error.value),
              );
            }
            final songIndex = song.currentIndex.value;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Colors.white,
                          size: 30,
                        )),
                    title: const Center(
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
                              builder: (context, scrollController) {
                                return globle_bottom_sheet(
                                  controllers: scrollController,
                                  song: song.current_song.value!,
                                  type: "queue",
                                );
                              },
                            ),
                            isScrollControlled: true,
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  ),
                  // todo after complete the project optimize the image appearence
                  // Card(
                  //   semanticContainer: true,
                  //   borderOnForeground: true,
                  //   shape: const CircleBorder(),
                  //   clipBehavior: Clip.hardEdge,
                  //   child: (song.current_song.value!.coverImage?.isNotEmpty ?? false)
                  //       ? CachedNetworkImage(
                  //           imageUrl: song.current_song.value!.coverImage ?? "",
                  //           errorWidget: (context, url, error) =>
                  //               const Icon(Icons.error),
                  //           fit: BoxFit.cover,
                  //         )
                  //       : Image.asset("assets/img.png"),
                  // ),
                  SizedBox(
                    height: 330,
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (value) {
                        if (value != song.currentIndex.value) {
                          song.currentIndex.value = value;
                        }
                      },
                      itemCount: song.queue.length,
                      itemBuilder: (context, index) {
                        final item = song.queue[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: (item.coverImage?.isNotEmpty ?? false)
                                  ? CachedNetworkImage(
                                      imageUrl: item.coverImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset("assets/img.png"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.current_song.value!.title ?? "Unknown",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Text(
                          song.current_song.value!.artist!
                              .map((artist) => artist.artistName)
                              .join(','),
                          style: const TextStyle(
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
                    padding: const EdgeInsets.only(top: 20.0),
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
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 10, bottom: 10),
                                child: GestureDetector(
                                  onTap: item.onTap,
                                  child: Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, left: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            item.icon,
                                            color: Colors.white,
                                          ),
                                          value == ''
                                              ? const SizedBox()
                                              : Text(
                                                  value,
                                                  style: const TextStyle(
                                                      color: Colors.white),
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
                  ),
                  // todo optimize the stream buffer and rebuild issue after complete the project.
                  Column(
                    children: [
                      SizedBox(
                        height: 70,
                        child: Obx(() {
                          final position = music_player.position.value;
                          final bufferposition =
                              music_player.buffer_position.value;
                          final duration = music_player.duration.value;
                          final max = duration.inMilliseconds.toDouble();
                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: SliderComponentShape.noThumb,
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: max == 0 ? 1 : max,
                                    value: bufferposition.inMilliseconds
                                        .clamp(0, duration.inMilliseconds)
                                        .toDouble(),
                                    onChanged: (_) {},
                                    activeColor: Colors.grey,
                                    inactiveColor: Colors.black,
                                  )),
                              Slider(
                                min: 0,
                                max: max == 0 ? 1 : max,
                                value: position.inMilliseconds
                                    .clamp(0, duration.inMilliseconds)
                                    .toDouble(),
                                onChanged: (value) {
                                  final seekTo =
                                      Duration(milliseconds: value.round());
                                  music_player.control_seek(seekTo);
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.transparent,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 50, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDuration(position),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      formatDuration(duration),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                song.shuffle_on_off();
                                // song.setQueue(song.queue.toList(), song.current_song.value!.id);
                              },
                              icon: const Icon(CupertinoIcons.shuffle),
                              color: song.isshuffleenabled.value
                                  ? Colors.white
                                  : Colors.grey,
                              iconSize: 30,
                            ),
                            IconButton(
                                onPressed: () async {
                                  await song.play_Previous();
                                },
                                icon: const Icon(Icons.skip_previous),
                                color: songIndex >0 ?Colors.white : Colors.grey,
                                iconSize: 40),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    music_player.togglePlayPause();
                                  },
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: music_player.animationController,
                                  ),
                                  color: Colors.black,
                                  iconSize: 60,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await song.play_Next();
                                },
                                icon: const Icon(Icons.skip_next),
                                color: songIndex < song.queue.length-1 ?Colors.white : Colors.grey,
                                iconSize: 40),
                            IconButton(
                                onPressed: () async {},
                                icon: const Icon(
                                    // download_controller
                                    // .Loopmode.value ==
                                    // LoopMode.off
                                    // ? Icons.repeat_rounded
                                    // : download_controller
                                    // .Loopmode.value ==
                                    // LoopMode.all
                                    // ? Icons.repeat_rounded
                                    // :
                                    Icons.repeat_one_outlined),
                                // color: download_controller
                                //     .Loopmode.value ==
                                //     LoopMode.off
                                //     ? Colors.grey
                                //     : Colors.white,
                                iconSize: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 65.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(Container(
                              height: 800,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                              ),
                              child: const List_song(),
                            ));
                          },
                          child: text("UP NEXT"),
                        ),
                        text("LYRICS"),
                        text("RELATED")
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class List_song extends StatefulWidget {
  const List_song({super.key});

  @override
  State<List_song> createState() => _List_songState();
}

class _List_songState extends State<List_song> {
  final current_song = Get.find<get_current_song>();

  @override
  void initState() {
    current_song.isReordering.value = true;
    super.initState();
  }

  @override
  void dispose() {
    current_song.isReordering.value = false;
    super.dispose();
  }

  void reOrder(int oldIndex, int newIndex) {
    final controller = current_song;
    if (newIndex > oldIndex) newIndex--;

    final queue = controller.queue;

    final movedSong = queue.removeAt(oldIndex);
    queue.insert(newIndex, movedSong);

    int current = controller.currentIndex.value;

    if (oldIndex == current) {
      controller.currentIndex.value = newIndex;
    } else if (oldIndex < current && newIndex >= current) {
      controller.currentIndex.value--;
    } else if (oldIndex > current && newIndex <= current) {
      controller.currentIndex.value++;
    }

    queue.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (current_song.queue.isEmpty) {
        return const Center(
          child:
              Text("No Song in Queue", style: TextStyle(color: Colors.white)),
        );
      }

      return ReorderableListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: current_song.queue.length,
        onReorder: reOrder,
        itemBuilder: (context, index) {
          final songss = current_song.queue[index];
          final isCurrent = current_song.currentIndex.value == index;
          return Dismissible(
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              current_song.dismissQueue(index);
            },
            key: ValueKey('dismiss_${songss.id}_${index}_${songss.hashCode}'),
            // key: UniqueKey(),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: isCurrent ? Colors.brown.shade500 : Colors.transparent,
              ),
              child: ListTile(
                onTap: () async {
                 await current_song.selectFromQueue(index);
                },
                leading: songss.coverImage != null
                    ? Image.network(songss.coverImage!)
                    : const Icon(Icons.music_note, color: Colors.white),
                title: Text(
                  songss.title ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  songss.artist
                          ?.map((artist) => artist.artistName)
                          .join(', ') ??
                      "",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
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
                            song: songss,
                            songIndex: index,
                            type: "queue",
                          );
                        },
                      ),
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

String formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}
