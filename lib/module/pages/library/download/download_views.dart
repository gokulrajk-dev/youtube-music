import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_music/module/pages/library/download/download_controller.dart';

class Download_Views extends GetView<download_Controller> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.allow.value
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                clipBehavior: Clip.hardEdge,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.songmodel.length,
                    itemBuilder: (context, index) {
                      final local_song = controller.songmodel[index];

                      return ListTile(
                        onTap: () {
                          Get.bottomSheet(download_song_bottom());
                          controller.playlist_song_loading(
                              controller.songmodel, index);
                        },
                        leading: QueryArtworkWidget(
                          id: local_song.id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(6),
                          nullArtworkWidget:
                              const Icon(Icons.music_note, size: 40),
                        ),
                        title: Text(
                          local_song.title,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          local_song.artist ?? "unknown Artist",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.bottomSheet(DraggableScrollableSheet(
                                  builder: (context, scrollController) =>
                                      download_song_bottom()));
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            )),
                      );
                    },
                  ),
                  Container(
                    height: 50,
                  )
                ],
              ),
            )
          : Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Allow to Access to the files',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await Permission.audio.request();
                        },
                        child: Text(
                          'Allow',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            );
    });
  }
}

class download_song_bottom extends StatefulWidget {
  download_song_bottom({
    super.key,
  });

  @override
  State<download_song_bottom> createState() => _download_song_bottomState();
}

class _download_song_bottomState extends State<download_song_bottom>
    with SingleTickerProviderStateMixin {
  final download_Controller download_controller =
      Get.find<download_Controller>();

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 500,
        child: Obx(() {
          final song = download_controller.currentSong;

          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(6),
                  nullArtworkWidget: const Icon(Icons.music_note, size: 40),
                ),
                title: Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                subtitle: Text(
                  song.artist ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
                trailing: IconButton(
                    onPressed: () async {
                      await download_controller.stop_song();
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        child: Obx(() {
                          final position = download_controller.position.value;
                          final bufferposition =
                              download_controller.buffer_position.value;
                          final duration = download_controller.duration.value;
                          final max = duration.inMilliseconds.toDouble();
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          thumbShape:
                                              SliderComponentShape.noThumb,
                                          overlayShape:
                                              SliderComponentShape.noOverlay,
                                          // trackHeight: 4,
                                        ),
                                        child: Slider(
                                          min: 0,
                                          max: max == 0 ? 1 : max,
                                          value: bufferposition.inMilliseconds
                                              .clamp(0, duration.inMilliseconds)
                                              .toDouble(),
                                          onChanged: (_) {},
                                          activeColor: Colors.red,
                                          inactiveColor: Colors.grey.shade800,
                                        )),
                                    Slider(
                                      min: 0,
                                      max: max == 0 ? 1 : max,
                                      value: position.inMilliseconds
                                          .clamp(0, duration.inMilliseconds)
                                          .toDouble(),
                                      onChanged: (value) {
                                        download_controller.control_seek(
                                            Duration(
                                                milliseconds: value.toInt()));
                                      },
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.transparent,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formatDuration(position),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            formatDuration(duration),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await download_controller
                                            .shuffle_mode();
                                      },
                                      icon: Icon(CupertinoIcons.shuffle),
                                      color: download_controller
                                              .isshuffleenabled.value
                                          ? Colors.white
                                          : Colors.grey,
                                      iconSize: 30,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await download_controller.pre_song();

                                        },
                                        icon: Icon(Icons.skip_previous),
                                        color: Colors.white,
                                        iconSize: 40),
                                    IconButton(
                                      onPressed: () async {
                                        await download_controller
                                            .contorller_for_song();
                                      },
                                      icon: AnimatedIcon(
                                        icon: AnimatedIcons.play_pause,
                                        progress: download_controller
                                            .animationController,
                                      ),
                                      color: Colors.white,
                                      iconSize: 80,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await download_controller.next_song();
                                        },
                                        icon: Icon(Icons.skip_next),
                                        color: Colors.white,
                                        iconSize: 40),
                                    IconButton(
                                        onPressed: () async {
                                          await download_controller
                                              .repeat_or_one();
                                        },
                                        icon: Icon(download_controller
                                                    .Loopmode.value ==
                                                LoopMode.off
                                            ? Icons.repeat_rounded
                                            : download_controller
                                                        .Loopmode.value ==
                                                    LoopMode.all
                                                ? Icons.repeat_rounded
                                                : Icons.repeat_one_outlined),
                                        color: download_controller
                                                    .Loopmode.value ==
                                                LoopMode.off
                                            ? Colors.grey
                                            : Colors.white,
                                        iconSize: 30),
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

String formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}
