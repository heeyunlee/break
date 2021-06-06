import 'package:algolia/algolia.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
Algolia algolia = Algolia.init(
  applicationId: '3RSFQTXAS4',
  apiKey: '3e2584021a567cec5216f5e224c80d8e',
);
