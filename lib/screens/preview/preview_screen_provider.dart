import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final previewScreenNotifierProvider = ChangeNotifierProvider(
  (ref) => PreviewScreenNotifier(),
);

class PreviewScreenNotifier extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void incrementCurrentPage() {
    _currentPage++;
    notifyListeners();
  }

  void decrementCurrentPage() {
    _currentPage--;
    notifyListeners();
  }

  void setCurrentPage(int pageIndex) {
    _currentPage = pageIndex;
    notifyListeners();
  }
}

final GlobalKey<NavigatorState> previewScreenNavigatorKey =
    GlobalKey<NavigatorState>();
