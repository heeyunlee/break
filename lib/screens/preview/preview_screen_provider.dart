import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final previewScreenModelProvider = ChangeNotifierProvider(
  (ref) => PreviewScreenModel(),
);

class PreviewScreenModel extends ChangeNotifier {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  int get currentPage => _currentPage;
  PageController get pageController => _pageController;

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

  static final previewImage = {
    'iosko': _iOSKorean,
    'iosen': _iOSEnglish,
    'androidko': _androidKorean,
    'androiden': _androidEnglish,
  };

  static final GlobalKey<NavigatorState> previewScreenNavigatorKey =
      GlobalKey<NavigatorState>();

  static const List<String> _iOSEnglish = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_1%403x.png?alt=media&token=af9cf15c-97fb-4690-acae-d78aa23fbb79',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_2%403x.png?alt=media&token=ef831774-ea03-4132-ab65-0146f7a3123c',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_3%403x.png?alt=media&token=bdeef957-91e3-4407-8203-0d6668f4cc1e',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_4%403x.png?alt=media&token=31f90817-effc-4c7e-9d43-b8864a12ce63',
  ];

  static const List<String> _iOSKorean = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_1%403x.png?alt=media&token=73460737-5833-469d-88e1-36ec4247b32d',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_2%403x.png?alt=media&token=eed6edfa-9b39-43ef-916f-13421e24872d',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_3%403x.png?alt=media&token=e40ee477-cc78-42b8-a0cb-5808d5d59b67',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_4%403x.png?alt=media&token=74e8cf69-2b08-41a8-be70-4ba1356f8428',
  ];

  static const List<String> _androidEnglish = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_1%403x.png?alt=media&token=270ae586-3336-4d95-bf73-a3cbedfdbd8e',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_2%403x.png?alt=media&token=e2ebbbe2-6950-4153-8d08-db88de1b9f11',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_3%403x.png?alt=media&token=941f93a7-7157-4e5a-aa95-7f1bfc2e4fd9',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_4%404x.png?alt=media&token=3c15d880-b5b6-49b0-b430-a431b82a5b13',
  ];

  static const List<String> _androidKorean = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_1%403x.png?alt=media&token=4d24b967-7397-462c-b29a-c332d43f0c7d',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_2%403x.png?alt=media&token=07fb8b0a-3796-415f-baca-6fb8f2a5c024',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_3%403x.png?alt=media&token=9291c32b-16ea-423b-a944-d4f18fed9658',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_4%403x.png?alt=media&token=cc92c485-b807-43da-9612-b71b8f18f930',
  ];
}
