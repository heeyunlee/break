import 'package:algolia/algolia.dart';
import 'package:workout_player/services/logging.dart';

import 'private_keys.dart';

class AlgoliaManager {
  Algolia initAlgolia() {
    const Algolia algolia = Algolia.init(
      applicationId: algoliaAppId,
      apiKey: algoliaKey,
    );
    logger.d('algolia initiated ${algolia.applicationId}');

    return algolia;
  }
}
