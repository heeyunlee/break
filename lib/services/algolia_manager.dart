import 'package:algolia/algolia.dart';
import 'package:workout_player/main_provider.dart';

import 'private_keys.dart';

class AlgoliaManager {
  static Algolia? _algolia;

  static Algolia init() {
    _algolia = Algolia.init(
      applicationId: PrivateKeys.algoliaAppId,
      apiKey: PrivateKeys.algoliaKey,
    );
    logger.d('algolia initiated ${_algolia?.applicationId}');

    return _algolia!;
  }
}
