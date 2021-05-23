import 'package:logger/logger.dart';

Logger logger = Logger();
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
