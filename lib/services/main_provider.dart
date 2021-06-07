import 'package:algolia/algolia.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class AlgoliaManager {
  static Algolia? _algolia;

  static Algolia init() {
    _algolia = Algolia.init(
      applicationId: '3RSFQTXAS4',
      apiKey: '3e2584021a567cec5216f5e224c80d8e',
    );

    return _algolia!;
  }
}

class KakaoManager {
  static const kakaoClientId = 'c17f0f1bc6e039d488fb5264fdf93a10';
}
