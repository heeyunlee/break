import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInChangeNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void toggleBoolValue() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setBoolean(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

final signInChangeNotifierProvider =
    ChangeNotifierProvider((ref) => SignInChangeNotifier());

final Map<String, List<String>> previewImages = {
  'iosko': _iOSKorean,
  'iosen': _iOSEnglish,
  'androidko': _androidKorean,
  'androiden': _androidEnglish,
};

final List<String> _iOSEnglish = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_1.png?alt=media&token=b4a6aaac-544b-455b-a884-f07e74f85e2f',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_2.png?alt=media&token=12c5c7ae-f535-4ddc-9b78-232f5d06cede',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_3.png?alt=media&token=9e03426c-b9a1-4131-ba36-3ce209b898d3',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_4.png?alt=media&token=b229b531-9c78-470d-9158-f54dfd5af7b8',
];
final List<String> _iOSKorean = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_1%403x.png?alt=media&token=0ef030bc-2301-45aa-9a64-e1dbe2373cab',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_2%403x.png?alt=media&token=5457b759-e744-441e-971b-95ef0e62c932',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_3%403x.png?alt=media&token=661954d9-a549-4530-b5b8-dbd163c124eb',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_4%403x.png?alt=media&token=7ef424f0-db90-431a-b4ac-1650bdb2bdf1',
];
final List<String> _androidEnglish = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_1.png?alt=media&token=9e5da9a9-a16b-4d04-87b7-c4c55bede755',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_2.png?alt=media&token=8d4c4cdb-3f5c-45f2-90ae-273d130bf265',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_3.png?alt=media&token=8dacc278-f31c-4c55-a46d-a57b77b5d2f8',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_4.png?alt=media&token=6856772c-b2af-467b-b418-6adaa357a119',
];
final List<String> _androidKorean = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_1.png?alt=media&token=d550d6bf-ac1a-409e-adce-4d14ca0eaed2',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_2.png?alt=media&token=97b7ba7e-cac5-40a4-8376-c2abb3cb2d92',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_3.png?alt=media&token=0d7507f2-7b22-4827-afe2-b9504c73529c',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_4.png?alt=media&token=bcb906b1-7bf2-4134-b171-2d6e3b625fb8',
];
