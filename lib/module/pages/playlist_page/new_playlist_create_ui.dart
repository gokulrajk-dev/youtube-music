import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/module/pages/playlist_page/playlist_controller.dart';

class newPlaylistCreate extends StatefulWidget {
  final List<int> songId;
   newPlaylistCreate({super.key,required this.songId});

  @override
  State<newPlaylistCreate> createState() => _newPlaylistCreateState();
}

class _newPlaylistCreateState extends State<newPlaylistCreate> {
  final Playlist_Controller playlist_song = Get.find<Playlist_Controller>();

  final TextEditingController playname = TextEditingController();

  final TextEditingController description = TextEditingController();

  
  @override
  void initState() {
    super.initState();
    playname.addListener((){
      setState(() {
      });
    });
  }
  
  @override
  void dispose() {
    playname.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "New playlist",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              autocorrect: true,
              autofocus: true,
              cursorColor: Colors.white,
              controller: playname,
              style: const TextStyle(
                color: Colors.white, // input text color
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.black,
              ),
            ),
            const Spacer(),
            TextField(
              autocorrect: true,
              autofocus: true,
              controller: description,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white, // input text color
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.black,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: playlist_song.isPublic.value,
                      onChanged: (value) {
                        playlist_song.ispubliced(value!);
                      },
                      autofocus: true,
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                    )),
                const Text(
                  'Public',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (playname.text.isNotEmpty) {
                        playlist_song.create_User_play(playname.text,
                            description.text, playlist_song.isPublic.value,widget.songId);
                      }
                      Get.back();
                    },
                    style: playname.text.isNotEmpty
                        ? const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white))
                        : const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white54)),
                    child: const Text(
                      'Create',
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
