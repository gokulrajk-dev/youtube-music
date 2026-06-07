import 'search_type.dart';

class SearchResult {
  final SearchType type;
  final Object data;

  const SearchResult({
    required this.type,
    required this.data,
  });
}