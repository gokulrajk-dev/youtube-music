import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/home/music_home_page.dart';
import 'package:youtube_music/module/pages/library/library_controller.dart';

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

  final Library_Nest_Page = [library_body(), Download_Views()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
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
                                      title: Text(
                                        'Views by',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Divider(),
                                    ListTile(
                                      onTap: () {
                                        library_controller.change_current_index(
                                            0, 'Library');
                                        Get.back();
                                      },
                                      title: Text(
                                        'Library',
                                        style: TextStyle(
                                            color: library_controller
                                                        .current_page_title ==
                                                    'Library'
                                                ? Colors.black
                                                : Colors.white,
                                            backgroundColor: library_controller
                                                        .current_page_title ==
                                                    'Library'
                                                ? Colors.white
                                                : Colors.transparent),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        library_controller
                                            .get_current_lib_index();
                                        Get.back();
                                      },
                                      title: Text(
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
                                      title: Text(
                                        'Device Files',
                                        style: TextStyle(
                                            color: library_controller
                                                        .current_page_title ==
                                                    'Device Files'
                                                ? Colors.black
                                                : Colors.white,
                                            backgroundColor: library_controller
                                                        .current_page_title ==
                                                    'Device Files'
                                                ? Colors.white
                                                : Colors.transparent),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
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
                          Get.toNamed(App_route.history_page,id: 4);
                        },
                        icon: Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
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
                                ? CircleAvatar(
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
                      child: Container(
                        color: Colors.black,
                        height: 100,
                        child: ListView.builder(
                          itemCount: text.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final texts = text[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Chip(label: Text(texts)),
                            );
                          },
                        ),
                      ),
                      height: 50),
                ),
                SliverToBoxAdapter(
                  child: Obx(
                    () => IndexedStack(
                      index: library_controller.current_library_index.value,
                      children: Library_Nest_Page,
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
                        shape: CircleBorder(),
                        onPressed: () {},
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : SizedBox(),
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
      // physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
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
            title: Text(
              'Liked Music',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            subtitle: Text(
              '📌 Auto playlist',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
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
            return Center(child: CircularProgressIndicator());
          }
          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Text(controller.error.value),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: playlist_song.user_playlist.length,
            itemBuilder: (context, index) {
              final playlist = playlist_song.user_playlist[index];
              return ListTile(
                onTap: () {
                  playlist_song.get_user_pick_song_playlist(playlist.id);
                  Get.toNamed(App_route.playlist_page, id: 4);
                },
                leading: playlist.playlistcoverimage == ''
                    ? Image.network(playlist.playlistcoverimage ?? "")
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.5)),
                        width: 55,
                        height: 55,
                        child: Icon(
                          Icons.music_note_outlined,
                          color: Colors.white,
                        )),
                title: Text(
                  playlist.playlistName ?? 'unknown',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: Text(
                  'Playlist . ${user.user.value!.userName}',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    )),
              );
            },
          );
        })
      ],
    );
  }
}
