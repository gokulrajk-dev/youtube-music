// import 'package:get/get.dart';
// import 'package:youtube_music/core/base/base_controller.dart';
// import 'package:youtube_music/data/user_respository/artist_respository.dart';
//
// import '../../../../data/data_module/song_module.dart';
// import '../../../../data/user_respository/song_respository.dart';
// import '../models/search_result.dart';
// import '../models/search_type.dart';
//
//
// class search_Controller extends base_controller {
//   final RxList<SearchResult> search_songs =
//       <SearchResult>[].obs;
//   final Song_Repository song_repository = Song_Repository();
//   final Artist_crud artist_crud = Artist_crud();
//   final searchtxt = "".obs;
//   final RxList<String> textSongSearch = <String>[].obs;
//
//   @override
//   void onInit() {
//     debounce(
//       searchtxt,
//       (value) async {
//         if (value.trim().length < 2) {
//           search_songs.clear();
//           textSongSearch.clear();
//           return;
//         }
//         await SongSearch(value);
//         textsongSearch();
//       },
//       time: const Duration(milliseconds: 400),
//     );
//     super.onInit();
//   }
//
//
//
//   @override
//   void onClose() {
//     clearsearch();
//     super.onClose();
//   }
//
//   Future<void> SongSearch(String query) async {
//
//     search_songs.clear();
//
//     final songs =
//     await song_repository.ssearch_song(query);
//
//     final artists =
//     await artist_crud.search_get_artist_list(query);
//
//     search_songs.addAll(
//       songs.map(
//             (e) => SearchResult(
//           type: SearchType.song,
//           data: e,
//         ),
//       ),
//     );
//
//     search_songs.addAll(
//       artists.map(
//             (e) => SearchResult(
//           type: SearchType.artist,
//           data: e,
//         ),
//       ),
//     );
//   }
//
//   void textsongSearch() {
//
//     final songs = search_songs
//         .where((e) => e.type == SearchType.song)
//         .map((e) => (e.data as Song).title ?? '')
//         .toSet()
//         .toList();
//
//     textSongSearch.assignAll(songs);
//   }
//
//   Future<void> set_to_search(String searchs) async {
//     textSongSearch.clear();
//     await SongSearch(searchs);
//   }
//
//   void clearsearch() {
//     searchtxt.value = '';
//     search_songs.clear();
//     textSongSearch.clear();
//   }
// }


import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/user_respository/artist_respository.dart';

import '../../../../data/data_module/song_module.dart';
import '../../../../data/user_respository/song_respository.dart';
import '../models/search_result.dart';
import '../models/search_type.dart';

class Search_Controller extends base_controller {
  // ─── State ───────────────────────────────────────────────────────────────
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isLoading = false.obs;

  // ─── Reactive text field value ────────────────────────────────────────────
  // The view writes into this; the debounce listens to it.
  final searchQuery = ''.obs;

  // ─── Repositories ────────────────────────────────────────────────────────
  final _songRepo = Song_Repository();
  final _artistRepo = Artist_crud();

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Debounce so we don't fire on every keystroke
    debounce(
      searchQuery,
      _onQueryChanged,
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    clearSearch();
    super.onClose();
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  Future<void> _onQueryChanged(String value) async {
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      searchResults.clear();
      suggestions.clear();
      return;
    }
    await _fetchResults(trimmed);
    _buildSuggestions();
  }

  Future<void> _fetchResults(String query) async {
    isLoading.value = true;
    searchResults.clear();

    try {
      final songs = await _songRepo.ssearch_song(query);
      final artists = await _artistRepo.search_get_artist_list(query);

      searchResults.addAll(
        songs.map((e) => SearchResult(type: SearchType.song, data: e)).toSet(),
      );
      searchResults.addAll(
        artists.map((e) => SearchResult(type: SearchType.artist, data: e)).toSet(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _buildSuggestions() {
    final titles = searchResults
        .where((e) => e.type == SearchType.song)
        .map((e) => (e.data as Song).title ?? '')
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
    suggestions.assignAll(titles);
  }

  // ─── Public ──────────────────────────────────────────────────────────────

  /// Called when the user taps a suggestion chip — bypasses debounce.
  Future<void> selectSuggestion(String query) async {
    suggestions.clear();
    searchQuery.value = query; // keeps text field in sync
    await _fetchResults(query);
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    suggestions.clear();
  }
}