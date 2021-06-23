import 'package:algolia/algolia.dart';

import 'private_keys.dart';

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