import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/playlist.dart';
import 'package:youtube_music/data/user_respository/user_playlist_respository.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../main_home_page/main_home_page_controller.dart';

class Playlist_Controller extends base_controller {
  final user_playlist_song = Rxn<Playlist>();
  final UserPlaylistCrud userPlaylistCrud = UserPlaylistCrud();
  final RxList<Playlist> user_playlist = <Playlist>[].obs;
  final UserPlaylistCrud playlistCrud = UserPlaylistCrud();
  final isPublic = true.obs;
  final main_page = Get.find<Main_Home_Page_Controller>();

  Future<void> show_user_playlist() async {
    try {
      get_isloading(true);
      noerror();
      final result = await playlistCrud.Get_user_playlist();
      user_playlist.value = result;
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

  Future<void> get_user_pick_song_playlist(int pickPlaylistId) async {
    try {
      get_isloading(true);
      noerror();
      user_playlist_song.value =
          await userPlaylistCrud.retrieveUserPlaylist(pickPlaylistId);
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

  void ispubliced(bool value) {
    isPublic.value = value;
  }

  Future<void> create_User_play(String playname, String description,
      bool isPublic, List<int> songId) async {
    try {
      final status = await playlistCrud.createUserPlaylist(
          playname, description, isPublic, songId);
      if (status!.statusCode == 201) {
        final data = status.data;
        await get_user_pick_song_playlist(data['id']);
        final naviId = NavHelper.getNavId(main_page.current_index.value);
        Get.toNamed(App_route.playlist_page, id: naviId);
        user_playlist.add(user_playlist_song.value!);
        user_playlist.refresh();
      }
    } catch (_) {}
  }

  Future<void> deleteExistPlaylist(int playlistId, int index) async {
    final status = await playlistCrud.deleteUserPlaylist(playlistId);
    if (status == 204) {
      user_playlist.removeAt(index);
    }
  }

  Future<void> addedSongToPlaylist(
      int playlistId, List<int> songId, String action) async {
    final status =
        await playlistCrud.songsAddedPlaylist(playlistId, songId, action);
    if (status == 201) {
      showGlobalMessage("Saved to playlist ${user_playlist_song.value!.playlistName}");
    } else {
      showGlobalMessage("this track is already added to the playlist");
    }
  }

  Future<void> removeSongFromPlaylist(
      int playlistId, List<int> songId, String action, int index) async {
    final status =
        await playlistCrud.songsAddedPlaylist(playlistId, songId, action);
    if (status == 204) {
      user_playlist_song.value!.songs!.removeAt(index);
      user_playlist_song.refresh();
      showGlobalMessage("Remove from playlist ${user_playlist_song.value!.playlistName}");
    }else{
      showGlobalMessage("no song found in the playlist");
    }
  }
}
