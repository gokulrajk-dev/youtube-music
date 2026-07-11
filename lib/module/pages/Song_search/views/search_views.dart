import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_music/data/data_module/album_module.dart';
import 'package:youtube_music/module/pages/Song_search/views/widgets/album_tile.dart';

import '../../../../data/data_module/artist.dart';
import '../../../../data/data_module/song_module.dart';
import '../../Song_search/models/search_type.dart';
import '../../Song_search/views/widgets/artist_tile.dart';
import '../../Song_search/views/widgets/song_tile.dart';
import '../../main_home_page/main_home_page_controller.dart';
import '../controllers/search_controller.dart';
import '../models/search_result.dart';

class SearchViews extends StatefulWidget {
  const SearchViews({super.key});

  @override
  State<SearchViews> createState() => SearchViewsState();
}

class SearchViewsState extends State<SearchViews>
    with RouteAware, WidgetsBindingObserver {
  // ─── Controllers ─────────────────────────────────────────────────────────
  late final TextEditingController _textController;
  final Search_Controller _controller = Get.find<Search_Controller>();
  final Main_Home_Page_Controller main = Get.find<Main_Home_Page_Controller>();

  // ─── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    // main.focusNode = FocusNode();
    // ✅ KEY FIX — Do NOT call requestFocus() here or in initState directly.
    // IndexedStack keeps all tabs alive. If we focus here, the keyboard pops
    // even when this tab is not visible.
    //
    // Instead, we only request focus when THIS widget is actually navigated
    // to and the frame is fully settled. We detect that via RouteAware below,
    // or by listening to when the user taps the search tab (handled in
    // MainHomePage via _onTabChanged callback — see MainHomePage fix).
    //
    // If this page is opened via Get.toNamed (not inside IndexedStack),
    // it is safe to focus after the first frame.
    WidgetsBinding.instance.addObserver(this);

    // Sync controller's reactive value → text field (e.g. suggestion tap)
    ever(_controller.searchQuery, (String val) {
      if (_textController.text != val) {
        _textController.text = val;
        // Move cursor to end
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: val.length),
        );
      }
    });
  }

  /// Called by MainHomePage when search tab becomes active.
  /// Public so the parent can invoke it after IndexedStack switches to index 1.
  void activateFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !main.focusNode.hasFocus) {
        main.focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    main.focusNode.dispose(); // ✅ dispose, never just unfocus
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  void _onClearTapped() {
    _textController.clear();
    _controller.clearSearch();
    // Keep keyboard open after clear
    main.focusNode.requestFocus();
  }

  void _onSuggestionTapped(String text) {
    _controller.selectSuggestion(text);
    // Dismiss suggestion list, keep keyboard for further edits
    main.focusNode.requestFocus();
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // ✅ resizeToAvoidBottomInset true (default) keeps scroll content
      // above the keyboard properly
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // ── Search App Bar ───────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.black,
            elevation: 0,
            // leading: IconButton(
            //   onPressed: helper_code.helper,
            //   icon: const Icon(CupertinoIcons.back, color: Colors.white),
            // ),
            title: _SearchBar(
              textController: _textController,
              focusNode: main.focusNode,
              onChanged: (value) {
                // Write to reactive observable → debounce fires
                _controller.searchQuery.value = value;
              },
              onClear: _onClearTapped,
            ),
            actions: const [_MicButton()],
          ),

          // ── Body ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            // Single Obx — no nested Obx needed
            child: Obx(() {
              final hasQuery = _controller.searchQuery.value.trim().length >= 2;
              final hasResults = _controller.searchResults.isNotEmpty;

              // Empty / idle state
              if (!hasQuery || !hasResults && !_controller.is_loading.value) {
                return _EmptyState(
                  isLoading: _controller.is_loading.value,
                  hasQuery: hasQuery,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Suggestions row
                  if (_controller.suggestions.isNotEmpty)
                    _SuggestionList(
                      suggestions: _controller.suggestions,
                      onTap: _onSuggestionTapped,
                    ),

                  // Loading shimmer / results
                  if (_controller.is_loading.value)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      ),
                    )
                  else
                    _ResultList(results: _controller.searchResults),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets (keeps build() readable)
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.textController,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(70),
          right: Radius.circular(70),
        ),
      ),
      child: TextField(
        controller: textController,
        focusNode: focusNode,
        maxLines: 1,
        // ✅ autofocus MUST be false — focus is requested manually
        autofocus: false,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          hintText: 'Search songs, artists and albums',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, color: Colors.white),
            splashRadius: 20,
          ),
        ),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white12,
        ),
        padding: const EdgeInsets.all(10),
        child: const Icon(CupertinoIcons.mic, color: Colors.white),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isLoading, required this.hasQuery});

  final bool isLoading;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    return SizedBox(
      height: height,
      child: Center(
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasQuery ? Icons.search_off : CupertinoIcons.search,
                    color: Colors.white24,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hasQuery
                        ? 'No results found'
                        : 'Search for songs, artists\nand albums',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.suggestions,
    required this.onTap,
  });

  final RxList<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length,
      itemBuilder: (_, index) {
        final text = suggestions[index];
        return ListTile(
          onTap: () => onTap(text),
          leading: const Icon(Icons.history, color: Colors.white54),
          title: Text(text, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(
            CupertinoIcons.arrow_up_left,
            color: Colors.white54,
            size: 18,
          ),
        );
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.results});

  final RxList<SearchResult> results;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (_, index) {
        final result = results[index];
        return switch (result.type) {
          SearchType.song => SongSearchTile(song: result.data as Song),
          SearchType.artist => ArtistSearchTile(artist: result.data as Artist),
          SearchType.album => AlbumSearchTile(album: result.data as Album),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
