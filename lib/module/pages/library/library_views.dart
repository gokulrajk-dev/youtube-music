import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/music_home_page.dart';
import 'package:youtube_music/module/pages/library/library_controller.dart';
import 'package:youtube_music/module/pages/playlist_page/new_playlist_create_ui.dart';

import '../../../route/app_route.dart';
import '../download/download_views.dart';
import '../home/controllers/user_data_controller.dart';
import '../playlist_page/playlist_controller.dart';

class Library_Views extends StatefulWidget {
  const Library_Views({super.key});

  @override
  State<Library_Views> createState() => _Library_ViewsState();
}

class _Library_ViewsState extends State<Library_Views> {
  final user_details_controller controller =
      Get.find<user_details_controller>();
  final Library_Controller library_controller = Get.find<Library_Controller>();

  List<String> text = [
    "Playlist",
    'Podcast',
    'Songs',
    'Album',
    'Artist',
  ];
  List<String> textDownload = [
    "Playlist",
    'Album',
    'Artist',
  ];

  final Library_Nest_Page = [const library_body(), Download_Views()];

  @override
  void initState() {
    super.initState();
  }

  Widget newPlaylist(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.black,
                    title: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          isDismissible: false,
                          DraggableScrollableSheet(
                            builder: (context, scrollController) {
                              return Scaffold(
                                backgroundColor: Colors.black,
                                body: Column(
                                  children: [
                                    ListTile(
                                      title: const Text(
                                        'Views by',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    ),
                                    const Divider(
                                      color: Colors.white12,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        library_controller.change_current_index(
                                            0, 'Library');
                                        Get.back();
                                      },
                                      leading: library_controller
                                                  .current_page_title ==
                                              'Library'
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      title: const Text(
                                        'Library',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        library_controller
                                            .get_current_lib_index();
                                        Get.back();
                                      },
                                      leading: library_controller
                                                  .current_page_title ==
                                              'Download'
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      title: const Text(
                                        'Download',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        library_controller.change_current_index(
                                            1, 'Device Files');
                                        Get.back();
                                      },
                                      leading: library_controller
                                                  .current_page_title ==
                                              'Device Files'
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      title: const Text(
                                        'Device Files',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Obx(
                        () => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              library_controller.current_page_title.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.white,
                              size: 13,
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Get.toNamed(App_route.history_page, id: 4);
                        },
                        icon: const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        color: Colors.black,
                      ),
                      Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(App_route.profile_page);
                          },
                          child: Obx(() {
                            final user = controller.user.value;
                            return user == null
                                ? const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/_joker1.png'),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.photoUrl),
                                  );
                          }),
                        );
                      })
                    ]),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: pinnedHeaderDelegate(
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        color: Colors.black,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Obx(
                            () => ListView.builder(
                              itemCount: library_controller.current_page_title ==
                                      'Library'
                                  ? text.length
                                  : textDownload.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final isLibrary =
                                    library_controller.current_page_title ==
                                        'Library';
                                final page = isLibrary ? text : textDownload;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8.0),
                                  child: Chip(
                                    label: Text(
                                      page[index],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      height: 50),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 1000,
                    child: Obx(
                      () => IndexedStack(
                        sizing: StackFit.loose,
                        index: library_controller.current_library_index.value,
                        children: Library_Nest_Page,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => library_controller.current_library_index.value == 0
                  ? Positioned(
                      bottom: 90,
                      right: 20,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        onPressed: () {
                          Get.bottomSheet(
                            isDismissible: false,
                            DraggableScrollableSheet(
                              builder: (context, scrollController) {
                                return Scaffold(
                                  backgroundColor: Colors.black,
                                  body: Column(
                                    children: [
                                      ListTile(
                                        title: const Text(
                                          'New',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            )),
                                      ),
                                      const Divider(
                                        color: Colors.white12,
                                      ),
                                      newPlaylist(
                                        Icons.playlist_add,
                                        'Playlist',
                                        () {
                                          Get.back();
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                  child: newPlaylistCreate(
                                                songId: const [],
                                              ));
                                            },
                                          );
                                        },
                                      ),
                                      newPlaylist(
                                        CupertinoIcons
                                            .dot_radiowaves_left_right,
                                        'Mix',
                                        () {
                                          Get.back();
                                        },
                                      ),
                                      newPlaylist(
                                        CupertinoIcons.person_2_fill,
                                        'Taste match',
                                        () {
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class library_body extends StatefulWidget {
  const library_body({super.key});

  @override
  State<library_body> createState() => _library_bodyState();
}

class _library_bodyState extends State<library_body> {
  final Library_Controller controller = Get.find<Library_Controller>();
  final user_details_controller user = Get.find<user_details_controller>();
  final Playlist_Controller playlist_song = Get.find<Playlist_Controller>();

  @override
  void initState() {
    playlist_song.show_user_playlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 20),
          child: Text(
            "Recently played",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(App_route.like_page, id: 4);
          },
          child: ListTile(
            style: ListTileStyle.drawer,
            leading: Image.asset('assets/liked_pic.png'),
            title: const Text(
              'Liked Music',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            subtitle: const Text(
              '📌 Auto playlist',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ),
        // ElevatedButton(
        //     onPressed: () {
        //       playlist_song.show_user_playlist();
        //     },
        //     child: Text('playlist')),
        Obx(() {
          if (controller.is_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Text(controller.error.value),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlist_song.user_playlist.length,
            itemBuilder: (context, index) {
              final playlist = playlist_song.user_playlist[index];
              return ListTile(
                onTap: () {
                  playlist_song.get_user_pick_song_playlist(playlist.id);
                  Get.toNamed(App_route.playlist_page, id: 4);
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          height: 130,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Delete this Playlist?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '\tCancel\t',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            playlist_song.deleteExistPlaylist(
                                                playlist.id, index);
                                            Get.back();
                                          },
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.white)),
                                          child: const Text(
                                            '\tDelete\t',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                leading: playlist.playlistcoverimage == ''
                    ? Image.network(playlist.playlistcoverimage ?? "")
                    : Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 0.5)),
                        width: 55,
                        height: 55,
                        child: const Icon(
                          Icons.music_note_outlined,
                          color: Colors.white,
                        )),
                title: Text(
                  playlist.playlistName ?? 'unknown',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: Text(
                  'Playlist . ${user.user.value!.userName} . ${playlist.songs!.length} Tracks',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    )),
              );
            },
          );
        }),
      ],
    );
  }
}
