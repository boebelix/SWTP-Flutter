import 'package:logger/logger.dart';

/// LogServie hilft beim Arbeiten
/// Informationen findest du hier https://pub.dev/packages/logger
class LogService {
  static final LogService _instance = LogService._internal();

  factory LogService() => _instance;

  LogService._internal();

  /// Mögliche Modi zur Ausgabe des Printstatements.
  /// logger.v("Verbose log");
  /// logger.d("Debug log");
  /// logger.i("Info log");
  /// logger.w("Warning log");
  /// logger.e("Error log");
  /// logger.wtf("What a terrible failure log");
  /// Der prettyLogger kann seht gut mit JSON umgehen
  var prettyLogger = Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 120,
        // width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  /// Mögliche Modi zur Ausgabe des Printstatements.
  /// logger.v("Verbose log");
  /// logger.d("Debug log");
  /// logger.i("Info log");
  /// logger.w("Warning log");
  /// logger.e("Error log");
  /// logger.wtf("What a terrible failure log");
  /// Standard Logger ohne Ausgabe
  var logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );
}
