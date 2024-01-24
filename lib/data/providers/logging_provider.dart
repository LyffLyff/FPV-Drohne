import 'package:logger/logger.dart';

class Logging {
  static final Logger _log = Logger();

  static void info(dynamic msg) {
    _log.i("INFO: $msg");
  }

  static void error(dynamic msg, {bool fatal = false}) {
    if (!fatal) {
      _log.e("ERROR: $msg");
    } else {
      _log.f("FATAL ERROR: $msg");
    }
  }

  static void debug(dynamic msg) {
    _log.d("DEBUG: $msg");
  }

  static void warning(dynamic msg) {
    _log.w("WARNING: $msg");
  }
}
