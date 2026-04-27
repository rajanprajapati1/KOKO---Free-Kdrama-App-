import 'package:flutter/foundation.dart';
import 'content_data.dart';

/// In-memory favorites store shared across the whole app via singleton.
/// Backed by ValueNotifier so widgets can reactively rebuild when the list changes.
class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  final ValueNotifier<List<KDramaContent>> favorites =
      ValueNotifier<List<KDramaContent>>([]);

  bool isFavorite(String contentId) =>
      favorites.value.any((c) => c.id == contentId);

  void toggle(KDramaContent content) {
    final current = List<KDramaContent>.from(favorites.value);
    final idx = current.indexWhere((c) => c.id == content.id);
    if (idx >= 0) {
      current.removeAt(idx);
    } else {
      current.insert(0, content); // newest first
    }
    favorites.value = current;
  }

  void remove(String contentId) {
    final current = List<KDramaContent>.from(favorites.value);
    current.removeWhere((c) => c.id == contentId);
    favorites.value = current;
  }
}
