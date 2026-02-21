import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/Album/album_controller.dart';
import 'package:youtube_music/module/pages/home/controllers/user_data_controller.dart';
import 'package:youtube_music/route/app_route.dart';

import '../globle_bottom_sheet/globle_bottom_sheet_views.dart';
import '../like_page/like_controller.dart';
import 'controllers/all_song_controller.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final user_details_controller controller =
      Get.find<user_details_controller>();
  final get_all_song_controller controller_song =
      Get.find<get_all_song_controller>();
  final get_current_song pick_current_song = Get.find<get_current_song>();
  final Like_Controller like = Get.find<Like_Controller>();
  final Album_Controller album_song = Get.find<Album_Controller>();

  // final GlobalKey<SliverAnimatedGridState> _gridKey =
  //     GlobalKey<SliverAnimatedGridState>();

  @override
  Widget build(BuildContext context) {
    return
        //   Scaffold(
        //   body: Center(child: Obx((){
        //     final user = controller.user.value;
        //     if(user==null) return CircularProgressIndicator();
        //     return Text('${user.gmail}');
        //   })),
        // );
        SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              // expandedHeight: 300,
              // flexibleSpace: FlexibleSpaceBar(
              //   collapseMode: CollapseMode.parallax,
              //   background: Stack(
              //     fit: StackFit.loose,
              //     children: [
              //       Image.asset('assets/_joker1.png'),
              //       Container(
              //         color: Colors.black.withOpacity(0.4),
              //       )
              //     ],
              //   ),
              // ),
              leading: TextButton.icon(
                onPressed: () {},
                label: Text(
                  'MUSIC',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  Icons.play_circle_outline,
                  color: Colors.red,
                ),
              ),
              leadingWidth: 110,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.history),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
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
                              backgroundImage: AssetImage('assets/_joker1.png'),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(user.photoUrl),
                            );
                    }),
                  );
                })
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: pinnedHeaderDelegate(
                height: 50,
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: const [
                      SizedBox(width: 10),
                      Chip(label: Text("Podcasts")),
                      SizedBox(width: 8),
                      Chip(label: Text("Romance")),
                      SizedBox(width: 8),
                      Chip(label: Text("Relax")),
                      SizedBox(width: 8),
                      Chip(label: Text("Feel Good")),
                      SizedBox(width: 8),
                      Chip(label: Text("party")),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Quick Picks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // profile
            // SliverToBoxAdapter(
            //   child: Obx(() {
            //     if (controller.isloading.value) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     if (controller.error.isNotEmpty) {
            //       return Center(
            //         child: Text(controller.error.value),
            //       );
            //     }
            //     if (controller.user.value == null) {
            //       return const Center(
            //         child: Text('no'),
            //       );
            //     }
            //
            //     final user = controller.user.value!;
            //
            //     return Padding(
            //       padding: const EdgeInsets.all(16),
            //       child: Column(
            //         children: [
            //           // CircleAvatar(
            //           //   radius: 50,
            //           //   backgroundImage: NetworkImage(user.photoUrl),
            //           // ),
            //           const SizedBox(height: 16),
            //           Text(
            //             user.userName,
            //             style: const TextStyle(
            //               fontSize: 22,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           const SizedBox(height: 8),
            //           Text(user.gmail),
            //           const SizedBox(height: 8),
            //           Text('Phone: ${user.phoneNumber}'),
            //         ],
            //       ),
            //     );
            //   }),
            // ),

            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) => ListTile(
            //       leading: const Icon(Icons.music_note),
            //       title: Text("Song $index"),
            //       subtitle: const Text("Artist"),
            //       trailing: const Icon(Icons.more_vert),
            //     ),
            //     childCount: 20,
            //   ),
            // ),
            // SliverAnimatedGrid(
            //   key: _gridKey,
            //   initialItemCount: 4,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 12,
            //     crossAxisSpacing: 12,
            //     childAspectRatio: 1,
            //   ),
            //   itemBuilder: (context, index, animation) {
            //     return FadeTransition(
            //       opacity: animation,
            //       child: ListTile(
            //         title: Text('$index'),
            //       )
            //     );
            //   },
            // ),

            SliverToBoxAdapter(
              child: SizedBox(
                  height: 100,
                  child: Obx(() {
                    if (controller_song.is_loading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (controller_song.songs.isEmpty) {
                      return Center(child: Text('No songs available'));
                    }

                    return PageView.builder(
                      itemCount: controller_song.songs.length,
                      controller: PageController(viewportFraction: 1),
                      itemBuilder: (context, index) {
                        final song = controller_song.songs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              pick_current_song
                                  .get_current_user_pick_song(song.id);
                            },
                            onLongPress: () {
                              Get.bottomSheet(
                                elevation: 5,
                                DraggableScrollableSheet(
                                  expand: false,
                                  builder: (context, scrollController) {
                                    return globle_bottom_sheet(
                                      controllers: scrollController,
                                      song_artist: song.artist,
                                      song_title: song.title,
                                      song_cover_img: song.coverImage,
                                      song_id: song.id,
                                    );
                                  },
                                ),
                                isScrollControlled: true,
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Image.network(song.coverImage ?? '',
                                      height: 70),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        song.title ?? "unknown",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        song.artist!
                                            .map((artist) => artist.artistName)
                                            .join(','),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Get.bottomSheet(
                                          elevation: 5,
                                          DraggableScrollableSheet(
                                            expand: false,
                                            builder:
                                                (context, scrollController) {
                                              return globle_bottom_sheet(
                                                controllers: scrollController,
                                                song_artist: song.artist,
                                                song_title: song.title,
                                                song_cover_img: song.coverImage,
                                                song_id: song.id,
                                              );
                                            },
                                          ),
                                          isScrollControlled: true,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Quick Picks Album",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                child: SizedBox(
                  height: 225,
                  child: Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: album_song.album_song.map((album) {
                          return album.songAlbum!.isEmpty
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    album_song.retrive_album_song_con(album.id);
                                    Get.toNamed(App_route.album_page, id: 1);
                                  },
                                  child: Container(
                                    width: 160,
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            clipBehavior: Clip.hardEdge,
                                            width: 150,
                                            height: 150,
                                            // margin: const EdgeInsets.symmetric(horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: album.coverImage ==
                                                            null
                                                        ? AssetImage(
                                                            'assets/_joker1.png')
                                                        : NetworkImage(
                                                            album.coverImage ??
                                                                "",
                                                          ))),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            album.title ?? "unknown",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            album.artists!
                                                .map(
                                                    (alart) => alart.artistName)
                                                .join(','),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Obx(
            //   ()=> SliverList(delegate: SliverChildListDelegate(
            //       album_song.album_song.map((song){
            //         return Column(
            //           children: [
            //             CircleAvatar(
            //               backgroundImage: NetworkImage(song.coverImage ?? ""),
            //             ),
            //             Text(song.songAlbum!.map((songname)=> songname.title).join(','))
            //           ],
            //         );
            //       }).toList()
            //   )),
            // ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      controller_song.get_all_songs();
                      like.get_current_user_like_songs();
                    },
                    child: Obx(() => Text(like.like_song
                        .map((f) => f.song!.title)
                        .toList()
                        .toString()))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 1100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class pinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  pinnedHeaderDelegate({required this.child, required this.height});

  double get minExtent => height;

  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      // color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant pinnedHeaderDelegate oldDelegate) {
    return false;
  }
}
