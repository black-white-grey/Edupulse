import 'package:flutter/material.dart';
import '../models/paper.dart';
import '../services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final List<Paper> _favorites = [];

  List<Paper> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final papers = await _dbService.getFavoritePapers();
    _favorites.clear();
    _favorites.addAll(papers);
    notifyListeners();
  }

  bool isFavorite(Paper paper) {
    return _favorites.any((p) => p.title == paper.title);
  }

  Future<void> toggleFavorite(Paper paper) async {
    if (isFavorite(paper)) {
      await _dbService.deletePaper(paper.title);
      _favorites.removeWhere((p) => p.title == paper.title);
    } else {
      await _dbService.insertPaper(paper);
      _favorites.add(paper);
    }
    notifyListeners();
  }
}
