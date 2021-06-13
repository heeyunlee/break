import 'package:algolia/algolia.dart';
import 'package:logger/logger.dart';
import 'package:workout_player/services/private_keys.dart';

Logger logger = Logger();
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class AlgoliaManager {
  static Algolia? _algolia;

  static Algolia init() {
    _algolia = Algolia.init(
      applicationId: '3RSFQTXAS4',
      apiKey: PrivateKeys.algoliaKey,
    );

    return _algolia!;
  }
}
