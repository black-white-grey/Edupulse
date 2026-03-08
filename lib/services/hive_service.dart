import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/paper.dart';

class HiveService {
  static const String favoritesBoxName = 'favorites_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(favoritesBoxName);
  }

  Box get _box => Hive.box(favoritesBoxName);

  Future<void> savePaper(Paper paper) async {
    await _box.put(paper.title, paper.toMap());
  }

  Future<void> deletePaper(String title) async {
    await _box.delete(title);
  }

  List<Paper> getFavoritePapers() {
    return _box.values.map((data) {
      return Paper.fromMap(Map<String, dynamic>.from(data as Map));
    }).toList();
  }

  bool isFavorite(String title) {
    return _box.containsKey(title);
  }

  ValueListenable<Box> get favoritesListenable => _box.listenable();
}
