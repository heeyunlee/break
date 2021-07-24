import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/services/algolia_manager.dart';

// TODO: Extract Search Model HERE

final searchModelProvider = ChangeNotifierProvider<SearchModel>(
  (ref) => SearchModel(),
);

class SearchModel extends ChangeNotifier {
  AlgoliaIndexReference algoliaIndexReference =
      AlgoliaManager.init().instance.index('dev_WORKOUTS');

  List<AlgoliaObjectSnapshot> _searchResults = [];
  List<AlgoliaObjectSnapshot> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _query = '';
  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
    } else {
      final snapshot = await algoliaIndexReference.query(query).getObjects();
      final hits = snapshot.hits;
      _searchResults = hits;
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    notifyListeners();
  }
}
