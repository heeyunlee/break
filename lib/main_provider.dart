import 'package:logger/logger.dart';

// Logger logger = Logger();
Logger logger = Logger(
  level: Level.nothing,
  printer: PrefixPrinter(
    PrettyPrinter(
      methodCount: 1, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 100, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
    debug: '[Herakles][D]',
    info: '[Herakles][I]',
    error: '[Herakles][E]',
    warning: '[Herakles][W]',
  ),
);

void initLogger(Level level) {
  logger = Logger(
    level: level,
    printer: PrefixPrinter(
      PrettyPrinter(
        methodCount: 1, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 100, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false, // Should each log print contain a timestamp
      ),
      debug: '[Herakles][D]',
      info: '[Herakles][I]',
      error: '[Herakles][E]',
      warning: '[Herakles][W]',
    ),
  );
}
