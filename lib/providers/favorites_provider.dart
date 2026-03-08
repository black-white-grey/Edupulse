import 'package:flutter/material.dart';
import '../models/paper.dart';
import '../services/hive_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  List<Paper> _favorites = [];

  List<Paper> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() {
    _favorites = _hiveService.getFavoritePapers();
    notifyListeners();
  }

  bool isFavorite(Paper paper) {
    return _hiveService.isFavorite(paper.title);
  }

  Future<void> toggleFavorite(Paper paper) async {
    try {
      if (isFavorite(paper)) {
        await _hiveService.deletePaper(paper.title);
      } else {
        await _hiveService.savePaper(paper);
      }
      _loadFavorites();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }
}
