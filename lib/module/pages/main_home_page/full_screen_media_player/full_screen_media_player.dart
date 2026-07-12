import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/module/pages/main_home_page/full_screen_media_player/full_screen_player_controller.dart';

import '../../../../core/action/action_context.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = music_player.pageControllerFull;
      if (controller.hasClients) {
        controller.jumpToPage(song.currentIndex.value);
      }
    });
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
              final songs = song.current_song.value;
              await like.post_del_user_like(songs!);
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
                            DraggableScrollableSheet(builder:
                                (BuildContext context,
                                    ScrollController scrollController) {
                              return ContextBottomSheet(
                                  controllers: scrollController,
                                  context: ActionContext(
                                      entityType: EntityType.song,
                                      entity: song.current_song.value,
                                      page: PageContext.queue,
                                      isOwner: false,
                                      isSaved: false));
                            }),
                            isScrollControlled: true,
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  ),
                  // todo after complete the project optimize the image appearence
                  SizedBox(
                    height: 330,
                    child: PageView.builder(
                      controller: music_player.pageControllerFull,
                      onPageChanged: (value) {
                        if (value != song.currentIndex.value) {
                          song.currentIndex.value = value;
                        }
                      },
                      itemCount: song.queue.length,
                      itemBuilder: (context, index) {
                        final item = song.queue[index];
                        return Stack(
                          children: [
                            Container(
                              height: 330,
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:
                                        (item.coverImage?.isNotEmpty ?? false)
                                            ? CachedNetworkImage(
                                                imageUrl: item.coverImage!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset("assets/img.png"),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 35),
                                child: Obx(
                                  () => Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Center(
                                            child: music_player.seekDirection
                                                            .value ==
                                                        direction.left &&
                                                    music_player.showSeek.value
                                                ? Text(
                                                    "${music_player.seekValue.value} seconds",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                          onDoubleTap: () async {
                                            await music_player.leftSeekJump();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Center(
                                            child: music_player.seekDirection
                                                            .value ==
                                                        direction.right &&
                                                    music_player.showSeek.value
                                                ? Text(
                                                    "+${music_player.seekValue.value} seconds",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                          onDoubleTap: () async {
                                            await music_player.rightSeekJump();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
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
                                color:
                                    songIndex > 0 ? Colors.white : Colors.grey,
                                iconSize: 40),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    await music_player.togglePlayPause();
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
                                color: songIndex < song.queue.length - 1
                                    ? Colors.white
                                    : Colors.grey,
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
  final get_all_song_controller controller_song =
      Get.find<get_all_song_controller>();
  final full_screen_media_player_controller music_player =
      Get.find<full_screen_media_player_controller>();

  @override
  void initState() {
    current_song.isReordering.value = true;
    ever(current_song.current_song, (newSong) async {
      if (newSong != null) {
        if (music_player.isRecom.value) {
          music_player.get_all_songsFilter('',
              current_song.current_song.value!.genre!.first.genreName ?? "");
        } else {
          music_player.songsFilter.clear();
        }
      }
    });
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

      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.queue_music_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "UP NEXT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Playing From",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          "${current_song.current_song.value!.title}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: current_song.queue.length,
                    onReorder: reOrder,
                    itemBuilder: (context, index) {
                      final songss = current_song.queue[index];
                      final isCurrent =
                          current_song.currentIndex.value == index;
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
                        key: ValueKey(
                            'dismiss_${songss.id}_${index}_${songss.hashCode}'),
                        // key: UniqueKey(),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Colors.brown.shade500
                                : Colors.transparent,
                          ),
                          child: ListTile(
                            onTap: () async {
                              await current_song.selectFromQueue(index);
                            },
                            leading: songss.coverImage != null
                                ? Container(
                                    height: 60,
                                    width: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: songss.coverImage!,
                                      fit: BoxFit.cover,
                                    ))
                                : const Icon(Icons.music_note,
                                    color: Colors.white),
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
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  elevation: 5,
                                  DraggableScrollableSheet(builder:
                                      (BuildContext context,
                                          ScrollController scrollController) {
                                    return ContextBottomSheet(
                                        controllers: scrollController,
                                        context: ActionContext(
                                            entityType: EntityType.song,
                                            entity: songss,
                                            page: PageContext.queue,
                                            songIndex: index,
                                            isOwner: false,
                                            isSaved: false));
                                  }),
                                  isScrollControlled: true,
                                );
                              },
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      "Auto-play",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Add similar content for endless listening",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Switch(
                      value: music_player.isRecom.value,
                      activeColor: Colors.black,
                      activeTrackColor: Colors.white,
                      inactiveThumbColor: Colors.white70,
                      inactiveTrackColor: Colors.grey.shade700,
                      onChanged: (value) async {
                        music_player.Recommentation_on_off(value);
                        if (music_player.isRecom.value) {
                          await music_player.get_all_songsFilter(
                              '',
                              current_song.current_song.value!.genre!.first
                                      .genreName ??
                                  "");
                        } else {
                          music_player.songsFilter.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 5),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller_song.genres.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final genre = controller_song.genres[index];
                            final selected_genre =music_player.genreIndex.value==index;
                            return GestureDetector(
                              onTap: () async {
                                music_player.changeGenreIndex(index);
                                if (music_player.isRecom.value) {
                                  await music_player.get_all_songsFilter(
                                      '', genre.genreName ?? "");
                                } else {
                                  music_player.songsFilter.clear();
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected_genre
                                      ? Colors.white
                                      : const Color(0xff2E2E2E),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    genre.genreName ?? "",
                                    style: TextStyle(
                                      color: selected_genre
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  music_player.is_loading.value
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : music_player.songsFilter.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "No Songs",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            )
                          : ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: music_player.songsFilter.length,
                              onReorder: reOrder,
                              itemBuilder: (context, index) {
                                final songss = music_player.songsFilter[index];
                                // final isCurrent = current_song.currentIndex.value == index;
                                return Dismissible(
                                  direction: DismissDirection.horizontal,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (_) {
                                    current_song.dismissQueue(index);
                                  },
                                  key: ValueKey(
                                      'dismiss_${songss.id}_${index}_${songss.hashCode}'),
                                  // key: UniqueKey(),
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(),
                                    child: ListTile(
                                      onTap: () async {
                                        await current_song
                                            .selectFromQueue(index);
                                      },
                                      leading: songss.coverImage != null
                                          ? Container(
                                              height: 60,
                                              width: 60,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: CachedNetworkImage(
                                                imageUrl: songss.coverImage!,
                                                fit: BoxFit.cover,
                                              ))
                                          : const Icon(Icons.music_note,
                                              color: Colors.white),
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
                                                ?.map((artist) =>
                                                    artist.artistName)
                                                .join(', ') ??
                                            "",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          Get.bottomSheet(
                                            elevation: 5,
                                            DraggableScrollableSheet(builder:
                                                (BuildContext context,
                                                    ScrollController
                                                        scrollController) {
                                              return ContextBottomSheet(
                                                  controllers: scrollController,
                                                  context: ActionContext(
                                                      entityType:
                                                          EntityType.song,
                                                      entity: songss,
                                                      page: PageContext.queue,
                                                      songIndex: index,
                                                      isOwner: false,
                                                      isSaved: false));
                                            }),
                                            isScrollControlled: true,
                                          );
                                        },
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

String formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}
